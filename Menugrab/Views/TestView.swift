//
//  TestView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/01/2021.
//

import SwiftUI
import Firebase

struct TestView: View {
    @ObservedObject var viewModel: TestViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.output)
                .padding()
            TextField("email", text: $viewModel.email)
            SecureField("password", text: $viewModel.password)
            Button("Sign up", action: { viewModel.sigUp() })
        }
    }
}

class TestViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var output: String = ""
    
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer,
        restaurant: Loadable<RestaurantDTO> = .notRequested
    ) {
        self.container = container
    }
    
    func sigUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .emailAlreadyInUse:
                    self.output = "email already in use"
                case .weakPassword:
                    self.output = "weak pass"
                default:
                    print(error.localizedDescription)
                }
            } else if let authResult = authResult {
                print("logged in!")
                let newUser = Auth.auth().currentUser
                self.output = newUser?.uid ?? "" + (newUser?.email ?? "")
            }
            
            
        }
    }
    
}

//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//    }
//}
