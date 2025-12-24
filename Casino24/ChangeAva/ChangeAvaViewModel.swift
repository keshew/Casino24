import SwiftUI

class ChangeAvaViewModel: ObservableObject {
    @Published var profileImageName: String = "av1" {
        didSet {
            UserDefaults.standard.set(profileImageName, forKey: "profileImageName")
        }
    }

}
