//
//  AudioTranscriptionRepository.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import Foundation
import AVFoundation
import Combine

// MARK: - Data Models
struct TranscriptionResponse: Codable {
    let text: String
}

struct OpenAITranscriptionRequest {
    let audioData: Data
    let fileName: String
    let mimeType: String
}

struct AffirmationRequest: Codable {
    let model: String = "gpt-3.5-turbo"
    let messages: [ChatMessage]
    let maxTokens: Int = 150
    let temperature: Double = 0.7
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case maxTokens = "max_tokens"
    }
}

struct ChatMessage: Codable {
    let role: String
    let content: String
}

struct AffirmationResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: ChatMessage
    }
}

// MARK: - Repository
class AudioTranscriptionRepository: NSObject, ObservableObject {
    
    // MARK: - Properties
    private let openAIApiKey = "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"
    
    private var audioRecorder: AVAudioRecorder?
    private var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var recordingURL: URL?
    
    @Published var isRecording = false
    @Published var transcriptionText = ""
    @Published var generatedAffirmation = ""
    @Published var isTranscribing = false
    @Published var isGeneratingAffirmation = false
    @Published var errorMessage: String?
    
    // MARK: - Audio Recording
    func startRecording() async throws {
        try await requestMicrophonePermission()
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsPath.appendingPathComponent("recording_\(Date().timeIntervalSince1970).m4a")
        recordingURL = audioFilename
        
        print("🎙️ STARTING AUDIO RECORDING...")
        print("📁 Recording to: \(audioFilename.lastPathComponent)")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        try audioSession.setCategory(.playAndRecord, mode: .default)
        try audioSession.setActive(true)
        
        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        
        guard let recorder = audioRecorder else {
            print("❌ Failed to create audio recorder")
            throw NSError(domain: "AudioRecording", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create audio recorder"])
        }
        
        if recorder.record() {
            await MainActor.run {
                isRecording = true
                errorMessage = nil
            }
            print("✅ Recording started successfully")
        } else {
            print("❌ Failed to start recording")
            throw NSError(domain: "AudioRecording", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to start recording"])
        }
    }
    
    func stopRecording() {
        print("🛑 STOPPING AUDIO RECORDING...")
        audioRecorder?.stop()
        
        Task { @MainActor in
            isRecording = false
        }
        
        // Start transcription process
        if let url = recordingURL {
            print("🔄 Starting transcription process...")
            Task {
                await transcribeAudio(from: url)
            }
        } else {
            print("❌ No recording URL found")
        }
    }
    
    private func requestMicrophonePermission() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            audioSession.requestRecordPermission { granted in
                if granted {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: NSError(domain: "AudioRecording", code: 3, userInfo: [NSLocalizedDescriptionKey: "Microphone permission denied"]))
                }
            }
        }
    }
    
    // MARK: - Audio Transcription
    private func transcribeAudio(from url: URL) async {
        await MainActor.run {
            isTranscribing = true
            errorMessage = nil
        }
        
        do {
            let audioData = try Data(contentsOf: url)
            let transcription = try await sendToWhisperAPI(audioData: audioData, fileName: url.lastPathComponent)
            
            await MainActor.run {
                transcriptionText = transcription
                isTranscribing = false
            }
            
            // Generate affirmation from transcription
            await generateAffirmationFromTranscription(transcription)
            
        } catch {
            await MainActor.run {
                errorMessage = "Transcription failed: \(error.localizedDescription)"
                isTranscribing = false
            }
        }
    }
    
    private func sendToWhisperAPI(audioData: Data, fileName: String) async throws -> String {
        let url = URL(string: "https://api.openai.com/v1/audio/transcriptions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openAIApiKey)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = createMultipartBody(
            audioData: audioData,
            fileName: fileName,
            boundary: boundary
        )
        request.httpBody = httpBody
        
        print("🎙️ Sending audio to Whisper API...")
        print("📁 Audio file size: \(audioData.count) bytes")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            print("❌ Whisper API Error: \(response)")
            throw NSError(domain: "TranscriptionAPI", code: 4, userInfo: [NSLocalizedDescriptionKey: "API request failed"])
        }
        
        let transcriptionResponse = try JSONDecoder().decode(TranscriptionResponse.self, from: data)
        let transcribedText = transcriptionResponse.text
        
        print("🎯 TRANSCRIBED AUDIO: \"\(transcribedText)\"")
        print("📝 Transcription length: \(transcribedText.count) characters")
        
        return transcribedText
    }
    
    private func createMultipartBody(audioData: Data, fileName: String, boundary: String) -> Data {
        var body = Data()
        
        // Add file field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add model field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("whisper-1".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add response_format field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"response_format\"\r\n\r\n".data(using: .utf8)!)
        body.append("json".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    // MARK: - Affirmation Generation
    private func generateAffirmationFromTranscription(_ transcription: String) async {
        guard !transcription.isEmpty else { return }
        
        await MainActor.run {
            isGeneratingAffirmation = true
        }
        
        do {
            let affirmation = try await sendAffirmationRequest(transcription: transcription)
            
            await MainActor.run {
                generatedAffirmation = affirmation
                isGeneratingAffirmation = false
            }
            
        } catch {
            await MainActor.run {
                errorMessage = "Affirmation generation failed: \(error.localizedDescription)"
                isGeneratingAffirmation = false
            }
        }
    }
    
    private func sendAffirmationRequest(transcription: String) async throws -> String {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openAIApiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = createTranscriptionAffirmationPrompt(transcription: transcription)
        
        let affirmationRequest = AffirmationRequest(
            messages: [
                ChatMessage(role: "system", content: "You are AstroFirm, an app that creates personalized cosmic affirmations. Based on what the user says, create an inspiring affirmation that connects their words to cosmic wisdom and space discoveries."),
                ChatMessage(role: "user", content: prompt)
            ]
        )
        
        let jsonData = try JSONEncoder().encode(affirmationRequest)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "AffirmationAPI", code: 5, userInfo: [NSLocalizedDescriptionKey: "Affirmation API request failed"])
        }
        
        let affirmationResponse = try JSONDecoder().decode(AffirmationResponse.self, from: data)
        return affirmationResponse.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    private func createTranscriptionAffirmationPrompt(transcription: String) -> String {
        return """
        The user has shared their thoughts or feelings: "\(transcription)"
        
        Create a personalized cosmic affirmation that:
        - Acknowledges their words and emotions
        - Connects their experience to cosmic wisdom or space phenomena
        - Provides encouragement and inspiration
        - Uses space metaphors (stars, galaxies, planets, cosmic forces, etc.)
        - Is 1-2 sentences long
        - Feels personal and empowering
        
        Example format: "Like [cosmic phenomenon], your [quality/strength] [inspirational statement]."
        
        Personalized Cosmic Affirmation:
        """
    }
    
    // MARK: - Cleanup
    func cleanup() {
        if let url = recordingURL {
            try? FileManager.default.removeItem(at: url)
        }
        recordingURL = nil
        
        Task { @MainActor in
            transcriptionText = ""
            generatedAffirmation = ""
            errorMessage = nil
        }
    }
}

// MARK: - AVAudioRecorderDelegate
extension AudioTranscriptionRepository: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            Task { @MainActor in
                errorMessage = "Recording failed"
                isRecording = false
            }
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        Task { @MainActor in
            errorMessage = "Recording error: \(error?.localizedDescription ?? "Unknown error")"
            isRecording = false
        }
    }
}
