
import UIKit
import Alamofire
import SwiftyJSON

class TaskListController: UITableViewController {
    var logoImageView: UIImageView!
    let cellId = "cellId"
    var notes : [Note] = [Note]()
    var filteredNotes : [Note] = [Note]()
    var searchController : UISearchController!
    var addButton : UIButton!
    var timer = Timer()
    var second : Double!
    let label = UILabel()
    var nonce = 0
    var expDate = Date()
    let urlAddNote = "http://217.64.140.182:5887/AddNote"
    let urlListNote = "http://217.64.140.182:5887/ListNotes"
    let urlDelNote = "http://217.64.140.182:5887/DelNote"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        setNavBar()
        loadNotes(url: urlListNote)
        tableView.allowsSelection = false
        setAddBt()
    }
    
    func remainTimeSection() {
        let timestampExp = ISO8601DateFormatter().string(from: expDate)
        let timestampNow = ISO8601DateFormatter().string(from: Date())
        let timestampExpInSecond = ISO8601DateFormatter().date(from: timestampExp)?.timeIntervalSinceReferenceDate
        let timestampNowInSecond = ISO8601DateFormatter().date(from: timestampNow)?.timeIntervalSinceReferenceDate
        second = timestampExpInSecond! - timestampNowInSecond!
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
    }
    
    @objc func counter()
    {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        second = second - 1
        let formattedString = formatter.string(from: TimeInterval(second))!

        label.text = "  Дедлайн закончится через " + formattedString
        
        if (second == 0)
        {
         print("TIME")
        }
    }
    
    @objc func pressed() {
        let alertVC = UIAlertController(title: "Add New Item", message: "What do you want to do?", preferredStyle: .alert)
        alertVC.addTextField(configurationHandler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
        let myTextField = (alertVC.textFields?.first)! as UITextField
        let parameters: [String: Any] = ["text" : myTextField.text!]
        self.addNotes(url: self.urlAddNote, parameters: parameters)
        self.tableView.reloadData()
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(addAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        
        let note: Note
        if isFiltering() {
            note = filteredNotes[indexPath.row]
        } else {
            note = notes[indexPath.row]
        }
        cell.textLabel!.text = note.note
        return cell
 
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredNotes = notes.filter({( note : Note) -> Bool in
            return note.note.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        label.backgroundColor = UIColor.customVeryWhiteColor
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let parameters: [String: Any] = ["id" : notes[indexPath.row].id]
            deleteNotes(url: urlDelNote, parameters: parameters)
            tableView.reloadData()
            }
        }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredNotes.count
        }
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func setNavBar()  {
        setLogoInNavBarIV()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = UIColor.customWhiteColor

        searchController = {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.placeholder = "Search Candies"
            controller.dimsBackgroundDuringPresentation = false
            definesPresentationContext = true
            return controller
        }()
        navigationItem.searchController = searchController
    }
    
    func setAddBt(){
        addButton = {
            let button = UIButton(type: UIButtonType.custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(#imageLiteral(resourceName: "plus").tint(with: UIColor.customGrayColor), for: .normal)
            button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
            return button
        }()
        let window = UIApplication.shared.keyWindow!
        window.addSubview(addButton)
        
        let constraints:[NSLayoutConstraint] = [
            addButton.bottomAnchor.constraint(equalTo: window.bottomAnchor/*, constant: -70*/),
            addButton.rightAnchor.constraint(equalTo: window.rightAnchor/*, constant: -70*/),
            addButton.heightAnchor.constraint(equalToConstant: 75),
            addButton.widthAnchor.constraint(equalToConstant: 75)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setLogoInNavBarIV() {
        logoImageView = {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "logoImage"))
            return imageView
        }()
        
        let constraints:[NSLayoutConstraint] = [
            
            logoImageView.widthAnchor.constraint(equalToConstant: 110),
            logoImageView.heightAnchor.constraint(equalToConstant: 25)
        ]
        NSLayoutConstraint.activate(constraints)
        
        navigationItem.titleView = logoImageView
    }
    
    func addNotes(url: String, parameters: [String: Any] ) {
        request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch statusCode{
            case 200..<300:
                self.loadNotes(url: self.urlListNote)
            case 403:
                TaskListController().present(LoginController(), animated: true, completion: nil)
            default:
                print("Error")}
        }
    }
    
    func deleteNotes(url: String, parameters: [String: Any]) {
        request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch statusCode{
            case 200..<300:
                self.loadNotes(url: self.urlListNote)
            case 403:
                TaskListController().present(LoginController(), animated: true, completion: nil)
            default:
                print("Error")}
        }
    }

    func loadNotes(url: String)  {//
        request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseJSON { response in
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode{
            case 200..<300:
                guard let cookies = HTTPCookieStorage.shared.cookies else {return}
                for cookie in cookies {
                    if (cookie.name == "msid") {
                        guard let expiresDate = cookie.value(forKey: "expiresDate") else {return}
                        self.expDate = expiresDate as! Date
                        if (self.nonce == 0){
                            self.remainTimeSection()
                            self.nonce = 1
                        }
                    }
                }
                
                let json = JSON(response.value!)
                print(json)
                let data = json.dictionary!["notes"]!
                do {
                    let rawData = try data.rawData()
                    do {
                        let decoder = JSONDecoder()
                        self.notes = try decoder.decode([Note].self, from: rawData)
                        self.tableView.reloadData()
                    } catch let jsonErr {
                        print("Failed to decode user:", jsonErr)
                    }
                } catch {
                    print("Error raw data user \(error)")
                }
            case 403:
                TaskListController().present(LoginController(), animated: true, completion: nil)
            default:
                print("Error")
            }
        }
    }
}

extension TaskListController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


