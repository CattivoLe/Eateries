//
//  PageViewController.swift
//  Eateries
//
//  Created by Alexander Omelchuk on 18.01.2019.
//  Copyright © 2019 Александр Омельчук. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    var headersArray = ["Записывайте","Находите"]
    var subHeadersArray = ["Создайте список любимых ресторанов","Найдите и отметьте на карте любимые рестораны"]
    var imagesAray = ["food","iphoneMap"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
    }
    
    func displayViewController(atIndex index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < headersArray.count else { return nil }
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewControler") as? ContentViewController else { return nil }
        
        contentVC.imageFile = imagesAray[index]
        contentVC.header = headersArray[index]
        contentVC.subHeader = subHeadersArray[index]
        contentVC.index = index
        
        return contentVC
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        return displayViewController(atIndex: index)
    }
}
