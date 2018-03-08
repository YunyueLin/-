//
//  ViewController.swift
//  合并图片并且存在本地沙盒中
//
//  Created by 林赟越 on 2018/3/8.
//  Copyright © 2018年 林赟越. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

extension ViewController{
    
    /// 合并图片为一张长图
    ///
    /// - Parameters:
    ///   - imgAry: 图片数组
    ///   - width: 长图的宽，默认为屏幕宽
    /// - Returns: 合成的图片
    func mergeImage(imgAry : [UIImage] , width : CGFloat = UIScreen.main.bounds.size.width) -> UIImage{
        var bigImgHeight : CGFloat = 0.0
        let bigImgWidth = width
        
        bigImgHeight = imgAry.reduce(0) { (currentHeight, img) -> CGFloat in
            return currentHeight + img.size.height
        }
        
        //开启画布
        UIGraphicsBeginImageContext(CGSize(width: bigImgWidth, height: bigImgHeight))
        
        var currentHeight : CGFloat = 0.0
        for img in imgAry {
            img.draw(in: CGRect(x: 0, y: currentHeight, width: img.size.width, height: img.size.height))
            currentHeight += img.size.height
        }
        
        
        let resultImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImg!
        
    }
    
    
    /// 保存图片到本地沙盒
    ///
    /// - Parameters:
    ///   - currentImage: 要保存的图片
    ///   - imageName: 保存的图片名
    /// - Returns: 保存完成之后的地址
    func saveImageReturnString( currentImage:UIImage, imageName:String = "image" ) -> String{
        let imageData = UIImageJPEGRepresentation(currentImage, 0.5)!;
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        //Home目录
        let homeDirectory = NSHomeDirectory()
        
        let documentPath = homeDirectory + "/Documents"
        //文件管理器
        let fileManager: FileManager = FileManager.default
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        do {
            try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch _ {
        }
        fileManager.createFile(atPath: "\(documentPath)/\(imageName)", contents: imageData as Data, attributes: nil)
        //得到选择后沙盒中图片的完整路径
        let filePath: String = String(format: "%@%@", documentPath, "/\(imageName)")
        
        do {
            if let url = URL(string: filePath) {
                try imageData.write(to: url, options: .atomic)
                
            }
        }
        catch _ {
            
        }
        return filePath
    }
}

