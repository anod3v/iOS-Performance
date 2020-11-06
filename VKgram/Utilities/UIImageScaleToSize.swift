//
//  UIImageScaleToSize.swift
//  VKgram
//
//  Created by Andrey on 01/11/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit


extension UIImage {
  func scaleToSize(size :CGSize) -> UIImage {
    if (self.size.equalTo(size)) {
      return self
    }

    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    self.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
}
