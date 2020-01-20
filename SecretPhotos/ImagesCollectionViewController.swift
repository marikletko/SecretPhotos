import UIKit
import CoreData
private let reuseIdentifier = "Cell"

class ImagesCollectionViewController: UICollectionViewController {
    
    var photos = [Photos]()
    
    let imagePicker = UIImagePickerController()
    var imageProperties:[ImageProperties] = UserDefaults.standard.value([ImageProperties].self, forKey: "ImageProperties") ?? []
    
    
    @IBAction func lala(_ sender: UIButton) {
        let defaults = UserDefaults.standard
           let dictionary = defaults.dictionaryRepresentation()
           dictionary.keys.forEach
               {
                   key in defaults.removeObject(forKey: key)
           }
        //UserDefaults.standard.set(nil, forKey: "ImageProperties")
       deleteAllRecords(in: "Photos")
    
    }
    
    func deleteAllRecords(in entity : String) // entity = Your_Entity_Name
    {

        let context = PersistenceServce.context
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        if #available(iOS 9, *)
        {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do
            {
                try context.execute(deleteRequest)
                try context.save()
            }
            catch
            {
                print("There was an error:\(error)")
            }
        }
        else
        {
            do{
                let deleteRequest = try context.fetch(deleteFetch)
                for anItem in deleteRequest {
                    context.delete(anItem as! NSManagedObject)
                }
            }
            catch
            {
                print("There was an error:\(error)")
            }
        }
        PersistenceServce.saveContext() // Note:- Replace your savecontext here with CoreDataStack.saveContext()
    }
    
    @IBAction func addPhotoButton(_ sender: UIButton) {
        pick()
    }
    
     override func viewWillAppear(_ animated: Bool) {
              //   UserDefaults.standard.synchronize() //
                     //     self.imageArr = UserDefaults.standard.value([BaseElement].self, forKey: "photos") ?? [] // чтобы фотка удалилась из мэйн коллекшн вью приходится еще раз считывать значения, это норм?
        let fetchRequest: NSFetchRequest<Photos> = Photos.fetchRequest()
        
        do {
            let image = try PersistenceServce.context.fetch(fetchRequest)
            self.photos = image
           self.collectionView.reloadData()
        } catch {}
        
        
         self.collectionView.reloadData()
           
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
        
        print(imageProperties.count)
    //
        
           
           self.imagePicker.delegate = self
           
         //  self.collectionView!.register(PhotoItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
           
           self.collectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
           
       }
    
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoItemCell
        let dataImage = photos[indexPath.row].photos
        let image = UIImage(data: dataImage!)
        cell.img.image = image
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc=ImagePreviewVC()
        vc.imageProperties = self.imageProperties
        vc.passedContentOffset = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let width = collectionView.frame.size.width/3
          let height = width
          return CGSize(width: width, height: height)
      }
    

    
    func pick() {
          self.imagePicker.sourceType = .photoLibrary
          self.present(self.imagePicker, animated: true, completion: nil)
      }
    
    
    struct DeviceInfo {
        struct Orientation {
            
            static var isLandscape: Bool {
                get {
                    return UIDevice.current.orientation.isValidInterfaceOrientation
                        ? UIDevice.current.orientation.isLandscape
                        : UIApplication.shared.statusBarOrientation.isLandscape
                }
            }
            
            static var isPortrait: Bool {
                get {
                    return UIDevice.current.orientation.isValidInterfaceOrientation
                        ? UIDevice.current.orientation.isPortrait
                        : UIApplication.shared.statusBarOrientation.isPortrait
                }
            }
        }
    }
    
    
}

