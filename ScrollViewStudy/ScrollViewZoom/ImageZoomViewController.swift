//
//  ImageZoomViewController.swift
//  ScrollViewStudy
//
//  Created by ByungHoon Ann on 2019/12/02.
//  Copyright © 2019 ByungHoon Ann. All rights reserved.
//

import UIKit
import Photos
class ImageZoomViewController: UIViewController,UIScrollViewDelegate {
    var asset : PHAsset!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageManager.requestImage(for: asset,
                                  targetSize: CGSize(width: asset.pixelWidth,
                                                     height: asset.pixelHeight),
                                  contentMode: .aspectFill,
                                  options: nil) { image, _ in
                                    self.imageView.image = image
        }

    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
