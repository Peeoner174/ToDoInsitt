
import UIKit

class LoginView: UIView {
    
    var goAction: (() -> Void)?
    var donateAction: (() -> Void)?
    
    var logoImageView: UIImageView!
    var appDescriptionLabel: UILabel!
    var goInBt: UIButton!
    var donateBt: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.customWhiteColor
        setLogoIV()
        setAppDescriptionL()

        setGoInBt()
        setDonateBt()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///
    func setLogoIV() {
        logoImageView = {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "TodoLogo"))
            // Включить автолейаут
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        //Добавление элемента в viewController
        addSubview(logoImageView)
        
        let constraints:[NSLayoutConstraint] = [
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            logoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            logoImageView.widthAnchor.constraint(equalToConstant: 234),
            logoImageView.heightAnchor.constraint(equalToConstant: 117)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setAppDescriptionL() {
        appDescriptionLabel = {
            let textView = UILabel()
            textView.text = "Составьте список дел на следующие 24 часа"
            
            guard let customFont = UIFont(name: "Helvetica", size: 24) else {
                fatalError("""
        Failed to load the "CustomFont-Light" font.
        Make sure the font file is included in the project and the font name is spelled correctly.
        """
                )
            }
            textView.font = UIFontMetrics.default.scaledFont(for: customFont)
            textView.adjustsFontForContentSizeCategory = true
            
            textView.numberOfLines = 5
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.textAlignment = .left
            return textView
        }()
        //Добавление элемента в viewController
        addSubview(appDescriptionLabel)
        
        let constraints:[NSLayoutConstraint] = [
            appDescriptionLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 100),
            appDescriptionLabel.widthAnchor.constraint(equalToConstant: 220),
            appDescriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 40)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setGoInBt(){
        goInBt = {
            let button = UIButton(type: UIButtonType.system)
            button.layer.cornerRadius = 10
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Начать", for: UIControlState.normal)
            button.titleLabel?.font = .systemFont(ofSize: 20)
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            button.backgroundColor = UIColor.customBlueColor
            button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
            return button
        }()
        addSubview(goInBt)
        
        let constraints:[NSLayoutConstraint] = [
            goInBt.topAnchor.constraint(equalTo: appDescriptionLabel.bottomAnchor, constant: 30),
            goInBt.centerXAnchor.constraint(equalTo: centerXAnchor),
            goInBt.widthAnchor.constraint(equalToConstant: 240),
            goInBt.heightAnchor.constraint(equalToConstant: 35)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func setDonateBt(){
        donateBt = {
            let button = UIButton(type: UIButtonType.system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("DONATE MONEY", for: UIControlState.normal)
            button.setTitleColor(UIColor.customPinkColor, for: UIControlState.normal)
            button.sizeToFit()
            button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
            return button
        }()
        addSubview(donateBt)
        
        let constraints:[NSLayoutConstraint] = [
            donateBt.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            donateBt.centerXAnchor.constraint(equalTo: centerXAnchor),
            donateBt.heightAnchor.constraint(equalToConstant: 35)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func handleLogin() {
        goAction?()
    }
    
    @objc func handleSignup() {
        donateAction?()
    }
}
