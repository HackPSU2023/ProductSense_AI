//
//  ContentView.swift
//  Landmarks
//
//  Created by Pallavi Das on 10/24/23.
//

import SwiftUI
import PythonKit
import UIKit

enum ActiveSheet: Identifiable {
    case none, loginSignup, login, signup, productSenseAIhome, productVerification, captureProductImage, imageReview, analyzingProduct, productInsights,feedbackInteraction

    var id: Int {
        switch self {
        case .none:
            return 0
        case .loginSignup:
            return 1
        case .login:
            return 2
        case .signup:
            return 3
        case .productSenseAIhome:
            return 4
        case .productVerification:
            return 5
        case .captureProductImage:
            return 6
        case .imageReview:
            return 7
        case .analyzingProduct:
            return 8
        case .productInsights:
            return 9
        case .feedbackInteraction:
            return 10
        }
    }
}

/*func runPythonScript() {
    let python = Python.shared
    let os = python.import("os")
    os.system("python3 /Users/pallavi/Desktop/hackpsu/app.py")
}*/

struct ContentView: View {
    @State private var purpleShade: Double = 0.5
    @State private var isLoading: Bool = false
    @State private var activeSheet: ActiveSheet? = nil
    @State private var userCredentials: [String: String] = [:]
    //@State var userCredentials: [String: String] = [:]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            /*Color.purple.edgesIgnoringSafeArea(.all)*/
            
            VStack {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.white)
                    .frame(width: 150, height: 150)
                    .mask(
                        RadialGradient(gradient: Gradient(colors: [Color.white, Color.clear]), center: .center, startRadius: 50, endRadius: 100)
                    )
                
                HStack(spacing: 0) {
                    Text("ProductSense")
                        .foregroundColor(.white)
                    Text("AI")
                        .bold()
                        .foregroundColor(.black)
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
                
            }
        }
        .background(Color.purple.opacity(purpleShade))
        .edgesIgnoringSafeArea(.all)
        .gesture(
            DragGesture().onChanged { value in
                let dragAmount = value.translation.width / UIScreen.main.bounds.width
                self.purpleShade = Double(dragAmount) + 0.5
                if self.purpleShade > 0.9 {
                    self.isLoading = true
                    
                    // Delay to simulate loading
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isLoading = false  // Stop the loading symbol
                        self.activeSheet = .loginSignup
                    }
                }
            }
        )
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.width > 50 {
                    self.activeSheet = .loginSignup
                }
            }
        )
        .fullScreenCover(item: $activeSheet) { item in
            switch item {
            case .login:
                LoginPage(activeSheet: $activeSheet, userCredentials: $userCredentials)
            case .signup:
                SignupPage(activeSheet: $activeSheet, userCredentials: $userCredentials)
            case .productSenseAIhome:
                //activeSheet: $activeSheet
                ProductSenseAIHomePage(activeSheet: $activeSheet)
            case .loginSignup:
                LoginSignupView(activeSheet: $activeSheet)
            case .productVerification:
                ProductVerificationPage(activeSheet: $activeSheet)
            case .captureProductImage:
                CaptureProductImage(activeSheet: $activeSheet)
            case .imageReview:
                ImageReview(activeSheet: $activeSheet)
            case .analyzingProduct:
                AnalyzingProduct(activeSheet: $activeSheet)
            case .productInsights:
                ProductInsights(activeSheet: $activeSheet)
            case .feedbackInteraction:
                FeedbackInteraction(activeSheet: $activeSheet)
            default:
                EmptyView()
            }
        }
    }
    /*func runPythonScript() {
            let python = Python.shared
            let os = python.import("os")
            os.system("python3 /Users/pallavi/Desktop/hackpsu/app.py")
    }*/
    
    
    struct SignupPage: View {
        @State private var name: String = ""
        @State private var usernameOrEmail: String = ""
        @State private var password: String = ""
        @State private var confirmPassword: String = ""
        /*@Binding var showLoginPage: Bool*/
        @Binding var activeSheet: ActiveSheet?
        @Binding var userCredentials: [String: String]
        //@State private var userCredentials: [String: String] = [:]
        //@State var userCredentials: [String: String] = [:]
        
        var body: some View {
            VStack {
                Text("Signup")
                    .font(.custom("SansSerif-Bold", size: 24))
                    .bold()
                
                TextField("Name", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                
                TextField("Username or Email", text: $usernameOrEmail)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                
                Button(action: {
                    // Logic to save the user details goes here...
                    self.userCredentials[self.usernameOrEmail] = self.password
                    self.activeSheet = .login
                }) {
                    Text("Enter")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.purple)
                }
            }
            .padding()
        }
    }
    
    struct LoginPage: View {
        @State private var username: String = ""
        @State private var password: String = ""
        /*@Binding var showHomePage: Bool*/
        @Binding var activeSheet: ActiveSheet?
        @Binding var userCredentials: [String: String]
        @State private var incorrectLoginAttempt: Bool = false
        @State private var retryCount: Int = 0
        
        var body: some View {
            VStack {
                Text("Login")
                    .font(.custom("SansSerif-Bold", size: 24))
                    .bold()
                
                TextField("Username or Email", text: $username)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                if incorrectLoginAttempt {
                    /*Text("Incorrect username or password. Please try again.")
                        .foregroundColor(.red)
                        .padding(.bottom, 10)*/
                    VStack(spacing: 5) {
                                        Text("Incorrect username or password. Please try again.")
                                            .foregroundColor(.red)
                                        
                                        Text("If new user, please signup first.")
                                            .foregroundColor(.red)

                                        Button(action: {
                                            self.activeSheet = .signup
                                        }) {
                                            Text("Signup")
                                                .font(.headline)
                                                .padding()
                                                .background(Color.white)
                                                .cornerRadius(10)
                                                .foregroundColor(.purple)
                                        }
                                        .padding(.top, 5)
                                    }
                                    .padding(.bottom, 10)
                }
                
                Button(action: {
                    // Logic to verify the username and password goes here...
                    if let storedPassword = userCredentials[username], storedPassword == password {
                            // Successful login
                            self.activeSheet = .productSenseAIhome
                            self.retryCount = 0
                            self.incorrectLoginAttempt = false
                        } else {
                            // Unsuccessful login
                            self.retryCount += 1
                            self.incorrectLoginAttempt = true
                            
                            if self.retryCount >= 3 {
                                self.retryCount = 0
                                self.activeSheet = .loginSignup
                            }
                        }
                    //self.activeSheet = .homePage
                }) {
                    Text("Enter")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.purple)
                }
            }
            .padding()
        }
    }
    
    struct ProductSenseAIHomePage: View {
        @Binding var activeSheet: ActiveSheet?
        //@State private var activeSheet: ActiveSheet? = nil
        var body: some View {
            ZStack {
                        LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.5), Color.black.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                        
                        ScrollView {
                            VStack {
                                HStack {
                                    Image(systemName: "arrow.left")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.white)
                                        .frame(width: 25)
                                        .padding()
                                        .onTapGesture {
                                            //self.activeSheet = Optional.none
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    self.activeSheet = nil
                                            }
                                        }
                                    Spacer()
                                }
                                
                                Text("ProductSense AI Homepage")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                
                                Text("Inspiration")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.top)
                                
                                Text("""
                                Shockingly, 1 in 10 individuals remain unaware of the skincare products they use, leading to skin and scalp damage, compounded by the overwhelming array of thousands of skincare and scalp care products available. ProductSense AI, a visionary venture inspired by the advancements in Large Language Models like OpenAI's GPT, seeks to simplify the complex world of skincare. We understand the struggle faced by consumers who dive into confusing ingredient lists, attempting to decode chemical terminology and hoping they've made the right choice for their skin. Our platform offers clear, concise insights on your daily skincare products, eliminating guesswork and providing actionable information at your fingertips. In a world of chaos, we aim to provide a breath of fresh air, guiding you confidently into the era of conscious consumerism. Start your journey with us today.
                                """)
                                    .foregroundColor(.white)
                                    .padding()
                                
                                Text("What it does")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.top)
                                
                                Text("""
                                ProductSense AI, as the name suggests, comes up with the most adequate responses, explained in simple terms that can be understood by a wide group of audiences ranging from naïve to experts in the field of skincare products. It allows users to capture an image of any skin care product and generates a summarized context of how beneficial or harmful it would prove to be based on its corresponding composition.
                                """)
                                    .foregroundColor(.white)
                                    .padding()

                                Button(action: {
                                    //runPythonScript()
                                    self.activeSheet = .captureProductImage
                                }) {
                                    Text("Verify your product")
                                        .font(.headline)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .foregroundColor(.purple)
                                }
                                .padding()
                                
                                /*.sheet(item: $activeSheet) { sheet in
                                    switch sheet {
                                    case .productVerification:
                                        ProductVerificationPage(activeSheet: $activeSheet)
                                    default: // Handle other cases if there are any
                                        EmptyView()
                                    }
                                }*/
                                Spacer()
                            }
                        }
                    }
            /*.sheet(item: $activeSheet) { sheet in
                        switch sheet {
                        case .productVerification:
                            ProductVerificationPage(activeSheet: $activeSheet)
                        default: // Handle other cases if there are any
                            EmptyView()
                        }
                    }*/
        }
        
    }
    
    struct ProductVerificationPage: View {
        @Binding var activeSheet: ActiveSheet?

        var body: some View {
            VStack {
                HStack {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 25)
                        .padding()
                        .onTapGesture {
                            //self.activeSheet = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.activeSheet = nil
                            }
                        }
                    Spacer()
                }

                // ... your content for the Product Verification page here ...

                Spacer()
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var isPresented: Bool
        @Binding var selectedImage: UIImage?
        var sourceType: UIImagePickerController.SourceType = .camera
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = sourceType
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            var parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.isPresented = false
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[.originalImage] as? UIImage {
                    parent.selectedImage = image
                }
                parent.isPresented = false
            }
        }
    }

    
    struct CaptureProductImage: View {
        @Binding var activeSheet: ActiveSheet?
        
        @State private var isCameraPresented: Bool = false
        @State var capturedImage: UIImage? = nil
        // Image placeholder for now, in a real scenario this would be
        // the image captured by the user
        //@State var capturedImage: Image = Image("placeholderImageName")
        
        var body: some View {
            VStack {
                Text("Scan Your Product")
                    .font(.title)
                Text("Capture a clear photo of the skincare product you want to verify.")
                // Camera Interface Placeholder:
                if let capturedImage = capturedImage {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 400)
                } 
                else {
                    Rectangle().frame(width: 300, height: 400)
                    }
                //Rectangle().frame(width: 300, height: 400)
                Text("Ensure good lighting for best results.")
                // Placeholder buttons to navigate through the flow:
                Button("Capture Image") {
                    // In reality, here you would integrate the camera capture functionality
                    self.activeSheet = .imageReview
                }
                .padding()
            }
            .fullScreenCover(isPresented: $isCameraPresented, content: {
                        ImagePicker(isPresented: $isCameraPresented, selectedImage: $capturedImage)
            })
            .onChange(of: capturedImage) {
                // Logic that executes when capturedImage changes.
                // The new value is not directly accessible here, but since you're just checking for nil,
                // you don't actually need it.
                if capturedImage != nil {
                    activeSheet = .imageReview // Move to the next page when the image is captured
                }
            }

        }
    }
    
    struct ImageReview: View {
        @Binding var activeSheet: ActiveSheet?
        // Placeholder for now
        @State var capturedImage: Image = Image("placeholderImageName")
        var body: some View {
            VStack {
                Text("Review your Image")
                capturedImage
                    .resizable()
                    .scaledToFit()

                Button("Retake") {
                    self.activeSheet = .captureProductImage
                }
                .padding()

                Button("Continue") {
                    self.activeSheet = .analyzingProduct
                }
                .padding()
            }
        }
    }
    
    struct AnalyzingProduct: View {
        @Binding var activeSheet: ActiveSheet?
        var body: some View {
            VStack {
                // Placeholder for a loading animation:
                Text("🔍")
                    .font(.system(size: 100))
                    .padding()
                Text("Analyzing product ingredients...")
            }
            .onAppear {
                // Simulating processing time:
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.activeSheet = .productInsights
                }
            }
        }
    }
    
    struct ProductInsights: View {
        @Binding var activeSheet: ActiveSheet?
        // Placeholder
        @State var productName: String = "Sample Product Name"
        var body: some View {
            VStack {
                Text("Product Insights")
                    .font(.title)
                Text(productName)
                // Implement your segmented control/tab view here for Benefits and Concerns

                Button("Get Detailed Insights") {
                    // Implement detailed insights view
                }
                .padding()

                Button("Save Report") {
                    // Implement saving functionality
                }
                .padding()

                Button("Share") {
                    // Implement sharing functionality
                }
                .padding()

                Button("Found this useful? Give Feedback") {
                    self.activeSheet = .feedbackInteraction
                }
                .padding()

                Button("Verify Another Product") {
                    self.activeSheet = .captureProductImage
                }
                .padding()
            }
        }
    }

    struct FeedbackInteraction: View {
        @Binding var activeSheet: ActiveSheet?
        var body: some View {
            VStack {
                Text("We're glad you found this useful!")
                // Implement feedback/rating system here

                Button("Back to Home") {
                    self.activeSheet = .productSenseAIhome
                }
                .padding()
            }
        }
    }
    
    struct LoginSignupView: View {
        //@Binding var showLoginSignupView: Bool
        /*@State private var showLoginPage: Bool = false
         @State private var showSignupPage: Bool = false
         @State private var showProductSenseAIHomePage: Bool = false*/
        @Binding var activeSheet: ActiveSheet?
        
        var body: some View {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 25)
                            .padding()
                            .onTapGesture {
                                //showLoginSignupView = false
                                self.activeSheet = nil
                            }
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Text("Login/Signup Page")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                    
                    Button(action: {
                        // Your login action here
                        self.activeSheet = .some(.login)
                    }) {
                        Text("Login")
                            .font(.headline)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                    }
                    .padding()
                    
                    
                    Button(action: {
                        // Your sign-up action here
                        self.activeSheet = .some(.signup)
                    }) {
                        Text("Signup")
                            .font(.headline)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
