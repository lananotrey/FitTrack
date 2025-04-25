import SwiftUI

struct OnboardingScreen: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            image: "figure.run",
            title: "Track Your Workouts",
            description: "Log your exercises, duration, and track your progress over time with detailed workout history."
        ),
        OnboardingPage(
            image: "flag.fill",
            title: "Set Fitness Goals",
            description: "Create personalized goals for workouts, exercise minutes, and calories burned. Monitor your progress with visual indicators."
        ),
        OnboardingPage(
            image: "chart.bar.fill",
            title: "View Your Progress",
            description: "Get insights into your fitness journey with detailed statistics and progress charts on your dashboard."
        )
    ]
    
    var body: some View {
        if hasCompletedOnboarding {
            ContentView()
        } else {
            onboardingView
        }
    }
    
    private var onboardingView: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: pages[index].image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .foregroundColor(.purple)
                            .padding()
                        
                        Text(pages[index].title)
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Text(pages[index].description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 32)
                        
                        Spacer()
                        
                        if index == pages.count - 1 {
                            Button(action: completeOnboarding) {
                                Text("Get Started")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.purple)
                                    )
                                    .padding(.horizontal, 32)
                            }
                        } else {
                            Button(action: { withAnimation { currentPage += 1 } }) {
                                Text("Next")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.purple)
                                    )
                                    .padding(.horizontal, 32)
                            }
                        }
                        
                        PageControl(numberOfPages: pages.count, currentPage: currentPage)
                            .padding(.bottom, 20)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
        }
    }
    
    private func completeOnboarding() {
        withAnimation {
            hasCompletedOnboarding = true
        }
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

struct PageControl: View {
    let numberOfPages: Int
    let currentPage: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { page in
                Circle()
                    .fill(page == currentPage ? Color.purple : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut, value: currentPage)
            }
        }
    }
}