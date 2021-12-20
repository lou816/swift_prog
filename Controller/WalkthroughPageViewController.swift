//
//  WalkthroughPageViewController.swift
//  Topic
//
//  Created by 詹禾稑 on 2021/11/27.
//

import UIKit

protocol WalkthroughPageViewControllerDelegate: AnyObject {
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController {
    
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate?
    var pageHeadings = ["開始您第一個著色圖片!", "選擇填色部位", "收藏畫好的圖片"]
    var pageImages = ["page1", "page2", "page3"]
    var pageSubHeadings = ["",
                           "拉動下面的滑塊來創造喜歡的顏色,按下OK後填色就完成囉！",
                           "按下右上角的儲存來決定要儲存在App裡或是存進相簿裡~"]
    var currentIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let startingViewContorller = contentViewController(at: 0) {
            setViewControllers([startingViewContorller], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }

}



extension WalkthroughPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        
        index -= 1
        return contentViewController(at: index)
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return contentViewController(at: index)
        
    }
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        return nil
    }
}

extension WalkthroughPageViewController: UIPageViewControllerDelegate {
   func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                currentIndex = contentViewController.index

                walkthroughDelegate?.didUpdatePageIndex(currentIndex: contentViewController.index)
            }
        }
    }
}
