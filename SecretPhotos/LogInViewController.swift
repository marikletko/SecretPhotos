import UIKit

class LogInViewController: UIViewController {
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let y = PasswordView()
        let x = y.instanceFromNin()
        x.delegate = self
        
        x.frame = CGRect(x: 40, y: 200, width: 286, height: 217)
        self.view.addSubview(x)
    }
    
    func checkPassword(insertPass:String) {
    
            if insertPass == password {
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ImagesCollectionViewController") as? ImagesCollectionViewController else { return }
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                let alert = UIAlertController(title: "Delete image", message: "Are u sure?", preferredStyle: .actionSheet)
                let okAction = UIAlertAction(title: "YES", style: .default , handler:nil)
                alert.addAction(okAction)
                self.present(alert,animated:true, completion: nil)
            }
        }
        
    }
    

extension LogInViewController: PasswordViewDelegate {
    func callback(_ someString: String) {
        checkPassword(insertPass:someString)
    }
}

