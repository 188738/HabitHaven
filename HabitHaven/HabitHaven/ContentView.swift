import SwiftUI
import FirebaseFirestore
import CryptoKit
import Foundation


struct TitleView: View {
    var body: some View {
        NavigationView { // Single root NavigationView
            ZStack {
                // Background
                Color.blue
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    
                    BarChart()
                    
                    // Title
                    Text("Habit Haven")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    // Login Button
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .frame(width: 200, height: 50)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    // Register Button
                    NavigationLink(destination: RegistrationView()) {
                        Text("Register")
                            .frame(width: 200, height: 50)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                }
            }
        }
    }
}





struct PrivacyNoticeView: View {
    
    var username: String
    var email: String
    var password: String
    var securityQuestion: String
    var securityAnswer: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                
                    
                    // Introduction
                    Text("Welcome to Habit Haven! Your privacy is important to us. This privacy notice explains how we collect, use, and protect your personal data.")
                    
                    Text("When you enter the app you type all of your goals in and when you want to acheieve them. Then you can generate a plan.")
                        .font(.body)
                    
                    // Data Collection Section
                    Text("1. Data We Collect")
                        .font(.headline)
                    Text("""
                    • Personal Information: Name, email address, and other registration details.
                    • Health Information: Data related to your fitness goals, weight, height, activity levels, and preferences.
                    """)
                        .font(.body)
                    
                    // Data Usage Section
                    Text("2. How We Use Your Data")
                        .font(.headline)
                    Text("""
                    • To provide personalized fitness recommendations and progress tracking.
                    • To improve app functionality and user experience.
                    • To send notifications and motivational reminders.
                    """)
                        .font(.body)
                    
                    // Data Sharing Section
                    Text("3. Sharing Your Data")
                        .font(.headline)
                    Text("""
                    • We do not sell your personal data.
                    • Your data may be shared with third-party services for app functionality (e.g., Firebase).
                    • Your data may be disclosed if required by law.
                    """)
                        .font(.body)
                    
                    // User Rights Section
                    Text("4. Your Rights")
                        .font(.headline)
                    Text("""
                    • You can access, update, or delete your data at any time through the app settings.
                    • You can withdraw consent for data processing or sharing at any time.
                    """)
                        .font(.body)
                    
                    // Contact Section
                    Text("5. Contact Us")
                        .font(.headline)
                    Text("""
                    If you have any questions about this privacy notice, please contact us at:
                    
                    Kousthub Sai Ganugapati
                    Email: kouthub.ganugapati@gmail.com
                    """)
                        .font(.body)
                    
                    Spacer()
                    
                    // Agree Button
                    NavigationLink(destination: OnboardingView(name: username, email: email, password: password, securityQuestion: securityQuestion, securityAnswer: securityAnswer)) {
                        Text("Agree")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.headline)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("Privacy Notice")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}

struct BarChart: View {
    let dataPoints: [CGFloat] = [50, 100, 75, 125, 150, 90] // Dummy data

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(0..<dataPoints.count, id: \.self) { index in
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 30, height: dataPoints[index])
            }
        }
        .padding()
        .background(Color.red.opacity(0.2))
        .cornerRadius(10)
        .frame(height: 200)
    }
}


struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var isLoggedIn: Bool = false
    @State private var userName: String = ""

    
    var body: some View {
        ZStack {
            // Background color
            Color.green
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Title
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                // Email Field
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                // Password Field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                
                
                
                // Login Button
                Button(action: {
                    handleLogin()
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .navigationBarBackButtonHidden(false)
                NavigationLink(destination: HomePage(userName: userName), isActive: $isLoggedIn) {
                    EmptyView()
                }
                
                NavigationLink(destination: ForgotPasswordView()) {
                                   Text("Forgot Password?")
                                       .underline()
                                       .foregroundColor(.white)
                               }
                
                // Back Button
                /*
                NavigationLink(destination: TitleView()) {
                    Text("Back")
                        .frame(width: 200, height: 50)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                 */
                
                Spacer()
            }
            
        }
        
    }
    
    func handleLogin() {
        // Validate inputs
        guard !email.isEmpty, !password.isEmpty else {
            print("Both email and password are required!")
            return
        }
        
        // Get Firestore instance
        let db = Firestore.firestore()
        
        // Query Firestore for a user with the provided email
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No user found with this email!")
                return
            }
            
            // Check if the password matches
            if let userData = documents.first?.data(), let storedPassword = userData["password"] as? String {
                if storedPassword == self.password {
                    print("Login successful!")
                    // Navigate to HomePage
                    isLoggedIn = true
                    userName = userData["name"] as? String ?? "User"
                } else {
                    print("Incorrect password!")
                }
            }
        }
    }
    
}

struct Goal: Identifiable, Codable {
    let id: String // Unique ID for the goal
    let name: String
    let completionDate: String
    var isCompleted: Bool
    var badge: Double
}


struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var securityQuestion: String = ""
    @State private var securityAnswer: String = ""
    @State private var enteredAnswer: String = ""
    @State private var isUserFound: Bool = false
    @State private var isAnswerCorrect: Bool = false
    @State private var errorMessage: String = ""
    @State private var userPassword: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Reset Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Username field
            TextField("Enter your username", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.none)
            
            // Button to fetch security question
            Button(action: {
                fetchSecurityQuestion(username: email)
            }) {
                Text("Find Security Question")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            // Display the security question if the user is found
            if isUserFound {
                Text("Security Question:")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(securityQuestion)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(8)
                
                // Answer field
                TextField("Enter your answer", text: $enteredAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                
                // Verify Answer Button
                Button(action: {
                    verifyAnswer()
                }) {
                    Text("Verify Answer")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            // Display the user's password if the answer is correct
            if isAnswerCorrect {
                Text("Your Password:")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(userPassword)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(8)
            } else if !errorMessage.isEmpty {
                // Display error message
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
    }
    
    func fetchSecurityQuestion(username: String) {
        // Clear previous state
        isUserFound = false
        isAnswerCorrect = false
        errorMessage = ""
        securityQuestion = ""
        securityAnswer = ""
        
        // Validate input
        guard !username.isEmpty else {
            errorMessage = "Username cannot be empty."
            return
        }
        
        let db = Firestore.firestore()
        
        // Query Firestore to check if the user exists
        db.collection("users")
            .whereField("name", isEqualTo: username)
            .getDocuments { snapshot, error in
                if let error = error {
                    // Handle errors
                    DispatchQueue.main.async {
                        errorMessage = "Error fetching user: \(error.localizedDescription)"
                    }
                    return
                }
                
                guard let documents = snapshot?.documents, let userData = documents.first else {
                    // No user found
                    DispatchQueue.main.async {
                        errorMessage = "No user found with this username."
                    }
                    return
                }
                
                // User found, fetch the security question and answer
                if let fetchedSecurityQuestion = userData.data()["securityQuestion"] as? String,
                   let fetchedSecurityAnswer = userData.data()["securityAnswer"] as? String {
                    DispatchQueue.main.async {
                        securityQuestion = fetchedSecurityQuestion
                        securityAnswer = fetchedSecurityAnswer
                        isUserFound = true
                    }
                } else {
                    DispatchQueue.main.async {
                        errorMessage = "Security question or answer not found for this user."
                    }
                }
            }
    }
    
    func verifyAnswer() {
        // Validate input
        guard !enteredAnswer.isEmpty else {
            errorMessage = "Please enter your answer."
            return
        }
        
        if enteredAnswer.lowercased() == securityAnswer.lowercased() {
            // Correct answer, fetch and display the password
            let db = Firestore.firestore()
            
            db.collection("users")
                .whereField("name", isEqualTo: email)
                .getDocuments { snapshot, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            errorMessage = "Error fetching user: \(error.localizedDescription)"
                        }
                        return
                    }
                    
                    guard let documents = snapshot?.documents, let userData = documents.first else {
                        DispatchQueue.main.async {
                            errorMessage = "No user found with this username."
                        }
                        return
                    }
                    
                    if let fetchedPassword = userData.data()["password"] as? String {
                        DispatchQueue.main.async {
                            userPassword = fetchedPassword
                            isAnswerCorrect = true
                            errorMessage = ""
                        }
                    } else {
                        DispatchQueue.main.async {
                            errorMessage = "Password not found for this user."
                        }
                    }
                }
        } else {
            // Incorrect answer
            DispatchQueue.main.async {
                errorMessage = "Incorrect answer. Please try again."
            }
        }
    }
}



struct PlanView: View {
    var userName: String // User's name to query Firestore
    
    @State private var userDetails: [String: Any] = [:] // Holds all user data
    @State private var loadingError: String? = nil // Error handling
    @State private var isLoading: Bool = true // Loading state
    @State private var generatedPlan: String = "Your personalized plan will appear here."

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading your personalized plan...")
                        .padding()
                } else if let error = loadingError {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Display the generated plan
                    ScrollView {
                        Text(generatedPlan)
                            .padding()
                            .font(.body)
                    }
                    .navigationTitle("Your Plan")
                }
            }
            .onAppear {
                fetchUserDataAndGeneratePlan()
            }
        }
    }

    // Fetch user data from Firestore and generate the plan automatically
    func fetchUserDataAndGeneratePlan() {
        print(generatedPlan)
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("name", isEqualTo: userName)
            .getDocuments { snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.loadingError = "Error fetching user data: \(error.localizedDescription)"
                        self.isLoading = false
                    }
                    return
                }
                
                guard let documents = snapshot?.documents, let userData = documents.first?.data() else {
                    DispatchQueue.main.async {
                        self.loadingError = "No user found with name \(userName)."
                        self.isLoading = false
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.userDetails = userData
                    
                    // Convert goals to [Goal]
                    if let rawGoals = userData["goals"] as? [[String: Any]] {
                        self.userDetails["goals"] = rawGoals.compactMap { dict in
                            if let id = dict["id"] as? String,
                               let name = dict["name"] as? String,
                               let completionDate = dict["completionDate"] as? String {
                                return Goal(id: id, name: name, completionDate: completionDate, isCompleted: false, badge: 0)
                            }
                            return nil
                        }
                    } else {
                        self.userDetails["goals"] = []
                    }
                    
                    generatePlanForUser()
                        
                }
            }
    }

    // Generate Plan using GPT
    func generatePlanForUser() {
        let db = Firestore.firestore()
        
        let prompt = """
        Based on the following user details, create a 7-day personalized diet and exercise plan:
        
        \(formatUserDetailsForGPT(userDetails: userDetails))
        
        
        Provide the plan day by day, including meals and exercises. I want a meal for breakfast and a youtube video with the recipe. I want a meal for lunch with the youtube video for the recipe. I want a meal for dinner with a youtube video and a recipe. I want this to work for all seven days in the week. I also want an excersize routine each day number of sets and reps of each excersize. I also want videos explaing them. If i say that i am allergic to a food i do not want that food or anything related to that food. If i am allergic to fish i am allergic to salmon.
        """
        print(prompt)
        fetchPlan(prompt: prompt) { result in
            DispatchQueue.main.async {
                if let plan = result {
                    self.generatedPlan = plan
                    // Get a reference to the Firestore database
                    let db = Firestore.firestore()

                        // Query the 'users' collection for a document where the 'name' field matches 'userName'
                        db.collection("users").whereField("name", isEqualTo: userName).getDocuments { (querySnapshot, error) in
                            if let error = error {
                                print("Error fetching user document: \(error.localizedDescription)")
                                return
                            }

                            // Check if we found matching documents
                            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                                print("No user found with name: \(userName)")
                                return
                            }

                            // Loop through the matching documents (there should ideally be only one match)
                            for document in documents {
                                let documentRef = document.reference
                                
                                // Update the 'plan' field in the matching document
                                documentRef.updateData([
                                    "plan": plan
                                ]) { error in
                                    if let error = error {
                                        print("Error updating plan in database: \(error.localizedDescription)")
                                    } else {
                                        print("Plan successfully updated for user: \(userName).")
                                    }
                                }
                            }
                        }
                } else {
                    self.generatedPlan = "Failed to generate a plan. Please try again."
                }
                self.isLoading = false
            }
        }
        
    }
    

    // Format user details into a prompt for GPT
    func formatUserDetailsForGPT(userDetails: [String: Any]) -> String {
        let name = userDetails["name"] as? String ?? "N/A"
        let age = userDetails["age"] as? String ?? "N/A"
        let height = userDetails["height"] as? String ?? "N/A"
        let weight = userDetails["weight"] as? String ?? "N/A"
        let BMI = userDetails["BMI"] as? Double ?? 0.0
        let BMR = userDetails["BMR"] as? Double ?? 0.0
        let dietaryRestrictions = userDetails["dietaryRestrictions"] as? String ?? "None"
        let healthConditions = userDetails["healthConditions"] as? String ?? "None"
        
        // Format goals
        var goalsDescription = ""
        if let goals = userDetails["goals"] as? [Goal] {
            for (index, goal) in goals.enumerated() {
                goalsDescription += "\(index + 1). \(goal.name) by \(goal.completionDate)\n"
            }
        } else {
            goalsDescription = "No goals."
        }

        print("It has reached the format user details for GPT")
        return """
        Name: \(name)
        Age: \(age)
        Height: \(height) cm
        Weight: \(weight) kg
        BMI: \(String(format: "%.2f", BMI))
        BMR: \(String(format: "%.2f", BMR))
        Dietary Restrictions: \(dietaryRestrictions)
        Health Conditions: \(healthConditions)
        Goals:
        \(goalsDescription)
        """
    }

    // Fetch plan from GPT API
    func fetchPlan(prompt: String, completion: @escaping (String?) -> Void) {
        let apiKey = getAPIKey() // Ensure API key is securely fetched
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        // Prepare parameters
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 1000,
            "temperature": 0.7
        ]
        print("It has reached the fetch plan")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 15 // Add timeout interval
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        // Make the API call
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error during request: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(nil)
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP Error: \(httpResponse.statusCode)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            // Parse the response
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(content.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    print("Invalid response format")
                    completion(nil)
                }
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    
    // Retrieve API key from a secure location
    func getAPIKey() -> String {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path),
           let apiKey = config["OPENAI_API_KEY"] as? String {
            return apiKey
        }
        fatalError("API key not found in Config.plist. Please add it.")
    }
}

struct GeneratedPlan: View {
    var username: String
    @State private var plan: String? = nil
    @State private var isLoading: Bool = true
    
    var body: some View {
        ScrollView{
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                } else if let plan = plan {
                    // Display the plan if it exists
                    Text("Hello \(username), here is your plan:")
                        .font(.headline)
                        .padding()
                    Text(plan)
                        .font(.body)
                        .padding()
                } else {
                    // Message when no plan exists
                    Text("No plan found for \(username).")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .onAppear {
                fetchPlan(for: username)
            }
        }
        
    }
    
    // Function to fetch the plan
    func fetchPlan(for username: String) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        
        collectionRef.whereField("name", isEqualTo: username).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching plan: \(error.localizedDescription)")
                isLoading = false
                return
            }
            
            // Check if a document with a "plan" attribute exists
            if let document = querySnapshot?.documents.first {
                self.plan = document.data()["plan"] as? String
            }
            
            // Stop loading
            isLoading = false
        }
    }
}


struct Badges: View {
    var username: String
    @State private var motivationalQuote: String = "..."
    @State private var badgeCount: Int = 0
    @State private var isLoading: Bool = true
    
    var body: some View {
        VStack(spacing: 20) {
            // Motivational Quote Section
            Text(motivationalQuote)
                .font(.headline)
                .italic()
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding()
                .onAppear {
                    fetchMotivationalQuote()
                    fetchBadges()
                }

            // Badges Section
            Text("Badges for \(username)")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            if badgeCount > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(1...badgeCount, id: \.self) { index in
                            VStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Text("\(index)")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    )
                                Text("Badge \(index)")
                                    .font(.caption)
                            }
                        }
                    }
                    .padding()
                }
                Text("You get a badge for each goal that you achieve")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                Text("No badges yet. Keep going!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }

    // Fetch motivational quote (can use an API or static logic for now)
    func fetchMotivationalQuote() {
        // Example static quotes
        let quotes = [
            "Success is not final, failure is not fatal: It is the courage to continue that counts.",
            "The only way to achieve the impossible is to believe it is possible.",
            "You don’t have to be great to start, but you have to start to be great.",
            "Your limitation—it’s only your imagination.",
            "The harder you work for something, the greater you’ll feel when you achieve it.",
            "Push yourself because no one else is going to do it for you.",
            "Fitness is not about being better than someone else. It’s about being better than you used to be.",
            "The pain you feel today will be the strength you feel tomorrow.",
            "Train insane or remain the same.",
            "Don’t count the days; make the days count.",
            "Your body can stand almost anything. It’s your mind you have to convince.",
            "If it doesn’t challenge you, it doesn’t change you."
        ];


        
        // Simulate fetching a random quote (could be replaced with an API call)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            motivationalQuote = quotes.randomElement() ?? "Keep pushing forward!"
        }
    }
    
    func fetchBadges() {
        // Reference to Firestore
        let db = Firestore.firestore()
        
        // Query the "users" collection for a document where "name" matches the username
        db.collection("users")
            .whereField("name", isEqualTo: username)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching badges: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents, let userDoc = documents.first else {
                    print("No user found with the name \(username)")
                    return
                }

                // Extract goals array from the user document
                if let goals = userDoc.data()["goals"] as? [[String: Any]] {
                    // Count the goals with "isCompleted" == true
                    let completedGoals = goals.filter { $0["isCompleted"] as? Bool == true }.count
                    
                    // Update badge count
                    DispatchQueue.main.async {
                        badgeCount = completedGoals
                        isLoading = false
                    }
                } else {
                    print("Goals array not found for user \(username)")
                    DispatchQueue.main.async {
                        isLoading = false
                    }
                }
            }
    }

}


struct HomePage: View {
    var userName: String
    @State private var navigateToUpdate: Bool = false
    @State private var height: Double = 0
    @State private var weight: Double = 0
    @State private var BMI: Double = 0
    @State private var BMR: Double = 0
    @State private var newGoal: String = ""
    @State private var completionDate: String = ""
    @State private var goals: [Goal] = []
    @State private var badge: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
            ZStack {
                // Background color
                Color.blue
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // User information displayed at the top
                    VStack {
                        Text("Hello \(userName)")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.3))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        
                        Text("Your Goals")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.3))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    .padding(.top, -20)
                    
                    // Goals list
                    VStack {
                        if goals.isEmpty {
                            Text("No goals yet. Add one below!")
                                .foregroundColor(.white)
                                .padding()
                        } else {
                            ForEach(goals) { goal in
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) { // Adjust spacing
                                        Text("Goal: \(goal.name)")
                                            .font(.subheadline) // Use a smaller font
                                            .padding(.bottom, 1)
                                        Text("Expected Completion: \(goal.completionDate)")
                                            .font(.caption) // Use an even smaller font
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 5) {
                                        Text("Completed?")
                                            .font(.caption2) // Tiny font
                                            .foregroundColor(.gray)
                                        Button(action: {
                                            // Toggle completion status and update in database
                                            toggleGoalCompletion(goalId: goal.id)
                                        }) {
                                            Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(goal.isCompleted ? .green : .gray)
                                        }
                                    }
                                }
                                .padding(8) // Reduce padding
                                .frame(maxWidth: .infinity)
                                .frame(height: 60) // Adjusted fixed height for checkmark space
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                                .padding(.vertical, 2) // Reduce vertical spacing between blocks
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Add new goal
                    VStack {
                        TextField("Enter your new goal", text: $newGoal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        TextField("Expected Completion Date 2025-(e.g., 2025-01-10)", text: $completionDate)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button(action: {
                            addGoal(userName: userName, goalName: newGoal, completionDate: completionDate)
                        }) {
                            Text("Add Goal")
                                .frame(width: 200, height: 25)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: GeneratedPlan(username: userName)){
                            Text("View Plan")
                                .frame(width: 200, height: 25)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: Badges(username: userName)){
                            Text("View Badges")
                                .frame(width: 200, height: 25)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        //This is the button to move to the screen which displays your personal plan
                        NavigationLink(destination: PlanView(userName: userName)) {
                            Text("Generate New Plan")
                                .frame(width: 200, height: 25)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        //This is the button to update the health information to mark progress accordingly
                        Button(action: {
                            updateProgress()
                        }) {
                            Text("Update Progress")
                                .frame(width: 200, height: 25)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(
                                                destination: Update(userName: userName),
                                                isActive: $navigateToUpdate
                                            ) {
                                                EmptyView()
                                            }
                        
                        Button(action: {
                                    dismiss() // Pops the current view from the navigation stack
                                }) {
                                    Text("Logout")
                                        .frame(width: 200, height: 25)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                        
                        
                        
                    }
                
                }
               
            }
            .onAppear {
                fetchUserData(userName: userName)
                fetchUserGoals(userName: userName)
            }
        }
        
        
    
    func toggleGoalCompletion(goalId: String) {
        print("The function is toggling")
        let db = Firestore.firestore()

        // Find the user by their name
        db.collection("users")
            .whereField("name", isEqualTo: userName)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching user: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents, let userDocument = documents.first else {
                    print("No user found with the name \(userName)")
                    return
                }

                let userID = userDocument.documentID
                print("The userId is \(userID)")

                // Fetch the user's document to access the goals array
                db.collection("users").document(userID).getDocument { document, error in
                    if let error = error {
                        print("Error fetching user document: \(error.localizedDescription)")
                        return
                    }

                    if let document = document, document.exists {
                        var data = document.data()
                        if var goalsArray = data?["goals"] as? [[String: Any]] {
                            // Find the specific goal by ID
                            if let index = goalsArray.firstIndex(where: { $0["id"] as? String == goalId }) {
                                // Toggle the `isCompleted` value
                                let isCompleted = goalsArray[index]["isCompleted"] as? Bool ?? false
                                goalsArray[index]["isCompleted"] = !isCompleted

                                // Update the user document with the modified goals array
                                db.collection("users").document(userID).updateData(["goals": goalsArray]) { error in
                                    if let error = error {
                                        print("Error updating goals: \(error.localizedDescription)")
                                    } else {
                                        print("Goal successfully updated!")
                                        
                                        
                                        
                                        // Update the local `goals` array to reflect the change
                                        if let localIndex = goals.firstIndex(where: { $0.id == goalId }) {
                                            DispatchQueue.main.async {
                                                goals[localIndex].isCompleted = !isCompleted
                                                if(goals[localIndex].isCompleted == true){
                                                    badge = true
                                                    //This will increment the amount of badges by 1
                                                    db.collection("users").document(userID).updateData(["badge": true])
                                                }
                                                
                                                
                                                
                                                
                                                
                                            }
                                        }
                                        
                                    }
                                }
                            } else {
                                print("Goal with ID \(goalId) not found in the goals array")
                            }
                        } else {
                            print("Goals field is missing or not an array")
                        }
                    } else {
                        print("User document does not exist")
                    }
                }
            }
    }



    
    func updateProgress() {
            print("The progress has been updated")
            navigateToUpdate = true // Trigger navigation
        }

    func logout() {
        // Clear any user session if needed
        // Navigate back to the login screen
        // Assuming you have a `NavigationLink` or a root view to handle navigation
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: LoginView())
            window.makeKeyAndVisible()
        }
    }
    
    func fetchUserData(userName: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("name", isEqualTo: userName)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching user data: \(error)")
                    return
                }

                guard let documents = snapshot?.documents, let userData = documents.first else {
                    print("No user found with the name \(userName)")
                    return
                }

                let data = userData.data()
                if let fetchedHeight = data["height"] as? Double,
                   let fetchedWeight = data["weight"] as? Double,
                   let fetchedBMI = data["BMI"] as? Double,
                   let fetchedBMR = data["BMR"] as? Double {
                    DispatchQueue.main.async {
                        self.height = fetchedHeight
                        self.weight = fetchedWeight
                        self.BMI = fetchedBMI
                        self.BMR = fetchedBMR
                    }
                } else {
                    print("Error parsing user data")
                }
            }
    }

    func fetchUserGoals(userName: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("name", isEqualTo: userName)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching user goals: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents, let userData = documents.first else {
                    print("No user found with the name \(userName)")
                    return
                }

                let data = userData.data()
                if let fetchedGoals = data["goals"] as? [[String: Any]] {
                    DispatchQueue.main.async {
                        self.goals = fetchedGoals.compactMap { dict in
                            if let id = dict["id"] as? String,
                               let name = dict["name"] as? String,
                               let completionDate = dict["completionDate"] as? String,
                               let isCompleted = dict["isCompleted"] as? Bool {
                                return Goal(id: id, name: name, completionDate: completionDate, isCompleted: isCompleted, badge: 0)
                            }
                            return nil
                        }
                    }
                }
            }
    }


    func addGoal(userName: String, goalName: String, completionDate: String) {
        guard !goalName.isEmpty, !completionDate.isEmpty else { return }

        let db = Firestore.firestore()
        db.collection("users")
            .whereField("name", isEqualTo: userName)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching user for adding goal: \(error)")
                    return
                }

                guard let documents = snapshot?.documents, let userDocument = documents.first else {
                    print("No user found with the name \(userName)")
                    return
                }

                let userID = userDocument.documentID
                let newGoal = Goal(id: UUID().uuidString, name: goalName, completionDate: completionDate, isCompleted: false, badge: 0)
                var updatedGoals = goals
                updatedGoals.append(newGoal)

                let goalsData = updatedGoals.map { ["id": $0.id, "name": $0.name, "completionDate": $0.completionDate, "isCompleted": false] }

                db.collection("users").document(userID).updateData(["goals": goalsData]) { error in
                    if let error = error {
                        print("Error updating goals: \(error)")
                        return
                    }
                    DispatchQueue.main.async {
                        self.goals = updatedGoals
                        self.newGoal = ""
                        self.completionDate = ""
                    }
                }
            }
    }
}


struct Update: View {
    var userName: String
    
    @State private var height: String = "" // Height in cm
    @State private var weight: String = "" // Weight in kg
    @State private var age: String = ""    // Age in years
    @State private var gender: String = "Male" // Gender for BMR calculation
    @State private var showConfirmation: Bool = false
    @State private var errorMessage: String? = nil // For error handling
    
    var body: some View {
        ZStack {
            Color.green
                .edgesIgnoringSafeArea(.all) // Background color
            
            VStack(spacing: 20) {
                Text("Update Your Information")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                // Height Field
                TextField("Enter your height (cm)", text: $height)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                
                // Weight Field
                TextField("Enter your weight (kg)", text: $weight)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                
                // Age Field
                TextField("Enter your age (years)", text: $age)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                
               
                
                // Submit Button
                Button(action: {
                    updateUserData()
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
        }
        .alert(isPresented: Binding<Bool>(
            get: { showConfirmation || errorMessage != nil },
            set: { _ in errorMessage = nil }
        )) {
            if let errorMessage = errorMessage {
                return Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            } else {
                return Alert(
                    title: Text("Information Updated"),
                    message: Text("Height: \(height) cm\nWeight: \(weight) kg\nAge: \(age) years\nBMI and BMR have been updated."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    // Update user data in Firestore
    func updateUserData() {
        guard !height.isEmpty, !weight.isEmpty, !age.isEmpty else {
            errorMessage = "All fields are required."
            return
        }
        
        guard let heightValue = Double(height), let weightValue = Double(weight), let ageValue = Int(age) else {
            errorMessage = "Invalid input. Please enter numbers only."
            return
        }
        
        // Calculate BMI and BMR
        let bmi = calculateBMI(height: heightValue, weight: weightValue)
        let bmr = calculateBMR(height: heightValue, weight: weightValue, age: ageValue, gender: gender)
        
        let db = Firestore.firestore()
        
        // Query the database for the user with the specified username
        db.collection("users").whereField("name", isEqualTo: userName).getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = "Error fetching user: \(error.localizedDescription)"
                return
            }
            
            guard let documents = snapshot?.documents, let document = documents.first else {
                self.errorMessage = "No user found with the username \(userName)."
                return
            }
            
            // Update the user's information
            document.reference.updateData([
                "height": heightValue,
                "weight": weightValue,
                "age": ageValue,
                "BMI": bmi,
                "BMR": bmr
            ]) { error in
                if let error = error {
                    self.errorMessage = "Error updating user data: \(error.localizedDescription)"
                } else {
                    self.showConfirmation = true
                }
            }
        }
    }
    
    // Calculate BMI
    func calculateBMI(height: Double, weight: Double) -> Double {
        return weight / ((height / 100) * (height / 100)) // Height is converted to meters
    }
    
    // Calculate BMR (using the Mifflin-St Jeor Equation)
    func calculateBMR(height: Double, weight: Double, age: Int, gender: String) -> Double {
        if gender == "Male" {
            return 10 * weight + 6.25 * height - 5 * Double(age) + 5
        } else {
            return 10 * weight + 6.25 * height - 5 * Double(age) - 161
        }
    }
}

struct BadgePage: View {
    
    var userName: String
    
    var body: some View {
        ZStack {
            Text("Hello \(userName)")
        }
    }
    
}


struct OnboardingView: View {
    var name: String
    var email: String
    var password: String
    var securityQuestion: String
    var securityAnswer: String
    @State private var height: String = "" // Bind to a String
    @State private var weight: String = "" // Bind to a String
    @State private var age: String = ""    // Bind to a String
    @State private var BMI: Double = 0
    @State private var BMR: Double = 0
    @State private var healthConditions: String = ""
    @State private var dietaryRestrictions: String = ""
    @Environment(\.presentationMode) var presentationMode // Environment property to control view dismissal
    
    var body: some View {
        ZStack {
            Color.orange
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10) {
                // Height Field
                TextField("Height (cm)", text: $height)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                
                // Weight Field
                TextField("Weight (kg)", text: $weight)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                
                // Age Field
                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                
                TextField("Health Conditions", text: $healthConditions)
                    .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                
                TextField("Dietary Restrictions", text: $dietaryRestrictions)
                    .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                
                // Calculate BMI and BMR Button
                Button(action: {
                    calculateMetrics()    // Call BMI and BMR calculation logic
                    handleRegister()      // Call registration logic
                   
                }) {
                    Text("Register this Info")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                Text("Press the back button and press the back button again until you go back to the home page and then login")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)

                
               
                
                

                
                // Display Results
                Text("BMI: \(BMI, specifier: "%.2f")")
                    .foregroundColor(.white)
                Text("BMR: \(BMR, specifier: "%.2f")")
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
    //Register Users
    func handleRegister() {
        
        
        // Get Firestore instance
        let db = Firestore.firestore()
        
        // Save data to the "users" collection
        db.collection("users").addDocument(data: [
            "name": name,
            "email": email,
            "password": password, // Note: In production, don't store plaintext passwords
            "height": height,
            "weight": weight,
            "age": age,
            "BMI": BMI,
            "BMR": BMR,
            "securityAnswer": securityAnswer,
            "securityQuestion": securityQuestion,
            "dietaryRestrictions": dietaryRestrictions,
            "healthConditions": healthConditions
        ]) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("User data saved successfully!")
                 // Navigate to TitlePage
            
            }
        }
       
        
        
    }
    
    // Calculate BMI and BMR
    func calculateMetrics() {
        guard let heightValue = Double(height),
              let weightValue = Double(weight),
              let ageValue = Double(age) else {
            print("Invalid input")
            return
        }
        
        // Calculate BMI
        BMI = weightValue / ((heightValue / 100) * (heightValue / 100))
        
        // Calculate BMR (using Mifflin-St Jeor Equation for males)
        BMR = 10 * weightValue + 6.25 * heightValue - 5 * ageValue + 5
    }
}



struct RegistrationView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isRegistered: Bool = false
    @State private var height: Double = 0
    @State private var weight: Double = 0
    @State private var securityQuestion: String = ""
    @State private var securityAnswer: String = ""
    
    var body: some View {
        ZStack {
            // Background color
            Color.green
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Title
                Text("Register")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                // Name Field
                TextField("Full Name", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .autocapitalization(.words)
                
                TextField("Security Question", text: $securityQuestion)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .autocapitalization(.words)
                
                TextField("Security Answer", text: $securityAnswer)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .autocapitalization(.words)
                
                // Email Field
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                // Password Field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                
                // Confirm Password Field
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                
               
                // Register Button
                Button(action: {
                    handleRegister()
                }) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: PrivacyNoticeView(username: name, email: email, password: password, securityQuestion: securityQuestion, securityAnswer: securityAnswer), isActive: $isRegistered) {
                    EmptyView()
                }
                
                Spacer()
            }
            
        }
    }
    
    func handleRegister() {
        // Validate inputs
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            print("All fields are required!")
            return
        }
       
        isRegistered = true
        print("success")
        
        
        
    }
    
    
    
}
