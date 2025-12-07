//
//  NewRestaurantController.swift
//  FoodPin
//
//  Created by  He on 2025/12/4.
//

import UIKit
import SwiftData

class NewRestaurantController: UITableViewController {
    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()//自动获取焦点
            nameTextField.delegate = self
        }
    }
    @IBOutlet var typeTextField: RoundedTextField! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    @IBOutlet var phoneTextField: RoundedTextField! {
        didSet {
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 5
            descriptionTextView.layer.cornerRadius = 10.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    @IBOutlet var photoImageView: UIImageView! {
        didSet {
            photoImageView.layer.cornerRadius = 10.0
            photoImageView.layer.masksToBounds = true
        }
    }
    
    var container: ModelContainer?
    var restaurant: Restaurant?
    var dataStore: RestaurantDataStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let appearance = navigationController?.navigationBar.standardAppearance {
            if let customFont = UIFont(name: "Nunito-Bold", size: 40) {
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle"), .font: customFont]
                
                navigationController?.navigationBar.standardAppearance = appearance
                navigationController?.navigationBar.compactAppearance = appearance
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
            }
        }
        
        //获取父View的内边距区域
        let margins = photoImageView.superview!.layoutMarginsGuide
        //关闭自动跳转大小遮罩, 这样就能避免冲突, 完全按代码来***非常重要***
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        //将photoImageView的前面鱼父View的内边距区域的前面对齐, 下面的同理
        photoImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        //创建一个手势识别器, 点击View时调用View的endEditing方法, 这个view即屏幕内容的根容器(UIViewController.view)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        //取消传递触摸给子view, 为true不传给子View
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        container = try? ModelContainer(for: Restaurant.self)
        restaurant = Restaurant()
    }
    
    //MARK: - checkFields 检查所有filed是否已填写内容
    func checkFields() -> Bool {
        if (!nameTextField.hasText || !typeTextField.hasText || !addressTextField.hasText || !phoneTextField.hasText || !descriptionTextView.hasText) {
            return false
        }
        return true
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if !checkFields() {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fileds is blank. Please note that all fileds are required.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
        } else {
            if let restaurant = restaurant {
                restaurant.name = nameTextField.text ?? ""
                restaurant.type = typeTextField.text ?? ""
                restaurant.location = addressTextField.text ?? ""
                restaurant.phone = phoneTextField.text ?? ""
                restaurant.summary = descriptionTextView.text ?? ""
                restaurant.isFavorite = false
                if let image = photoImageView.image {
                    restaurant.image = image
                }
                do {
                    container?.mainContext.insert(restaurant)
                    try container?.mainContext.save() // 👈 必须调用
                } catch {
                    print("❌ 保存失败: \(error)")
                }
                
                dismiss(animated: true) {
                    self.dataStore?.fetchRestaurantData()
                }
            }
        }
        
    }
}

extension NewRestaurantController: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()//移除当前焦点
            nextTextField.becomeFirstResponder()//下一个View获取焦点
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            //弹窗
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                //硬件支持且有权限
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    
                    self.present(imagePicker, animated: true)
                }
            }
            
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            photoSourceRequestController.addAction(cancelAction)
            
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            present(photoSourceRequestController, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        dismiss(animated: true)
    }
}
