
import UIKit
import Alamofire
import SwiftyJSON

class LoginController: UIViewController {
    
    var signView: LoginView!
    
    let urlLogin = "http://217.64.140.182:5887/Login"
    let postReqParameters: [String: Any]? = ["login":"1234"]
    var expDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        let url = "http://217.64.140.182:5887/ListNotes"
        request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).validate().responseJSON { response in
            guard let statusCode = response.response?.statusCode else { return }
            if (statusCode == 200){
                let mainVC = UINavigationController(rootViewController: TaskListController())
                self.show(mainVC, sender: nil)
            }
        }
    }
    
    func setupView() {
        signView = {
            let imageView = LoginView()
            imageView.goAction = donatePress
            imageView.donateAction = goPress
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        view.addSubview(signView)
        
        let constraints:[NSLayoutConstraint] = [
            signView.topAnchor.constraint(equalTo: view.topAnchor),
            signView.leftAnchor.constraint(equalTo: view.leftAnchor),
            signView.rightAnchor.constraint(equalTo: view.rightAnchor),
            signView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func donatePress() {
        print("donate button pressed")
        
    }
    
    func goPress() {
        
        loginUser(url: urlLogin, parameters: postReqParameters!)
        
        let taskController = UINavigationController(rootViewController: TaskListController())
        present(taskController, animated: true, completion: nil)

    }
}

///
func loginUser(url: String, parameters: [String : Any])  {
    
    request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).validate().responseJSON { response in
        guard let statusCode = response.response?.statusCode else { return }
        
        switch statusCode{
        case 200..<300: break
     
        case 403:
            print("Авторизоваться не удалось, проверьте валидность параметров запроса ")
        default:
            print("Ошибка установки соединения с сервером")
        }
    }
}












