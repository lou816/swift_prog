//
//  PaintingViewController.swift
//  Topic
//
//  Created by 詹禾稑 on 2021/11/22.
//

import UIKit
import CoreData


class PaintingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 回傳只有一列
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 回傳總共有幾個資料（行）
        return pictureMasks[pictureIndex].masks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 回傳資料名稱（行）
        return pictureMasks[pictureIndex].pickerNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 在picker選擇後把選擇的部位原始圖做成mask
        let image = UIImage(named: pictureMasks[pictureIndex].masks[row])
        let mask = UIImageView(image: image)
        mask.frame = maskView.bounds
        mask.contentMode = .scaleAspectFit
        maskView.mask = mask
    }
    
    
    
    // MARK: - IBOutlet & variable
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var maskPicker: UIPickerView!
    @IBOutlet weak var okButton: UIButton!
    
    
    var pictureIndex = 0
    var pictureImages = ""
    
    var basePicture: UIImage!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    maskPicker.dataSource = self
    maskPicker.delegate = self

    // 取消大標題
    navigationItem.largeTitleDisplayMode = .never
        
    // 拿取原始底圖當暫存原始底圖
    pictureImageView.image = basePicture
        
    // 一進去用一張部位原始圖當一開始的遮罩
    let image = UIImage(named: pictureMasks[pictureIndex].masks[0])
    let mask = UIImageView(image: image)
    mask.frame = maskView.bounds
    mask.contentMode = .scaleAspectFit
    mask.alpha = 0
    maskView.mask = mask
        
        
    }
    
    // MARK: - IBAction
        
    // 更改部件顏色
    @IBAction func changeColor(_ sender: Any) {
        maskView.mask?.alpha = 1
        maskView.backgroundColor = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1)
    }
    
    // 按下OK按鈕後 儲存顏色並畫入暫存原始底圖
    @IBAction func saveColor(sender: UIButton) {
        let image = UIImage(named: pictureMasks[pictureIndex].masks[maskPicker.selectedRow(inComponent: 0)])?.withTintColor(UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1))
        pictureImageView.image = painting(source: pictureImageView.image!, target: image!, size: pictureImageView.image!.size)
    }

    @IBAction func savePicture(sender: UIButton){
        let saveController = UIAlertController(title: "", message: "請選擇", preferredStyle: .alert)
        let saveInPhotoLibaryAction = UIAlertAction(title: "存到相簿", style: .default, handler: { (action) in
            let image = self.pictureImageView.image
            let imageSaver = ImageSaver()
            imageSaver.writeToPhotoAlbum(image: image!)
            let cmpString = self.pictureImages
            let fetchRequest: NSFetchRequest<Picture> = Picture.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", cmpString)
                do {
                    let item = try context.fetch(fetchRequest)
                    if (item.count > 0) {
                        let target = item[0]
                        target.image = self.pictureImageView.image!.pngData()!
                        appDelegate.saveContext()
                    }
                } catch {
                }
                
            }
        })
        let saveToPictureAction = UIAlertAction(title: "儲存填色", style: .default, handler: { (action) in
            let cmpString = self.pictureImages
            let fetchRequest: NSFetchRequest<Picture> = Picture.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", cmpString)
                do {
                    let item = try context.fetch(fetchRequest)
                    if (item.count > 0) {
                        let target = item[0]
                        target.image = self.pictureImageView.image!.pngData()!
                        appDelegate.saveContext()
                    }
                } catch {
                }
                
            }
        })
        let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)
        saveController.addAction(saveToPictureAction)
        saveController.addAction(saveInPhotoLibaryAction)
        saveController.addAction(cancelAction)
        present(saveController, animated: true, completion: nil)
    }
//
    // MARK: - function
    
    // 兩張圖畫在一起
    func painting(source: UIImage, target: UIImage, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        
        source.draw(at: CGPoint(x: 0.0, y: 0.0))
        target.draw(at: CGPoint(x: 0.0, y: 0.0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}


class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}


extension PaintingViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
}
