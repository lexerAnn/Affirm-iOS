// Updated SceneDelegate.swift sections to uncomment after adding files to Xcode:

// In scene(_:willConnectTo:options:) method:
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Create window programmatically
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: windowScene)
    
    // Check if user has completed onboarding
    let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    if hasCompletedOnboarding {
        showMainApp()
    } else {
        showOnboarding()  // ← Uncomment this line
    }
    
    window?.makeKeyAndVisible()
}

// In showOnboarding() method:
func showOnboarding() {
    let onboardingVC = OnboardingContainerViewController()  // ← Uncomment this line
    window?.rootViewController = onboardingVC              // ← Uncomment this line
}
