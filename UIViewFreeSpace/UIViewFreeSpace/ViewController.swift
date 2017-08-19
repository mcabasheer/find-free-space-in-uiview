//
//  ViewController.swift
//  UIViewFreeSpace
//
//  Created by Basheer Ahamed on 19/8/17.
//  Copyright © 2017 Basheer. All rights reserved.
//

import UIKit


extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var mainView : UIView?
    var mainShapeLayer : CAShapeLayer? = nil
    let newViewWidth : CGFloat = 100
    let newViewHeight : CGFloat = 50
    var tryCount = 0
    let path : UIBezierPath = UIBezierPath.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated : Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        mainShapeLayer = CAShapeLayer()
        mainShapeLayer?.frame = (mainView?.frame)!
        mainShapeLayer?.fillColor = UIColor.blueColor().CGColor
        mainShapeLayer?.fillRule = "1"
        mainView?.layer.addSublayer(mainShapeLayer!)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addNewView(sender: UIButton) {
        var viewFound = false
        tryCount = 0
        // Run this loop until new view frame is found
        while (viewFound == false) {
            tryCount += 1
            
            if tryCount > 50 {
                // exit the loop
                viewFound = true
                print("Unable to find empty space")
            }
            
            // get a random point
            let point = self.getRandomPoint()
            
            // estimate the four edges of the new view
            let edge1 = CGPointMake(point.x-newViewWidth/2, point.y - newViewHeight/2)
            let edge2 = CGPointMake(edge1.x + newViewWidth, edge1.y)
            
            let edge3 = CGPointMake(edge1.x, edge1.y + newViewHeight)
            
            let edge4 = CGPointMake(edge1.x + newViewWidth, edge1.y +
                newViewHeight)
            
            // check all the four edges are visible in mainView
            if mainShapeLayer?.containsPoint(edge1) == true &&  mainShapeLayer?.containsPoint(edge2) == true && mainShapeLayer?.containsPoint(edge3) == true && mainShapeLayer?.containsPoint(edge4) == true {
                
                // all edges are within main view
                let edgeArray = [edge1, edge2, edge3, edge4]
                var tempFlag = false
                
                for point in edgeArray {
                    tempFlag = path.containsPoint(point)
                    if tempFlag == true {
                        break
                    }
                }
                
                if tempFlag == false {
                    // edges are not overlapping with any subview
                    // new view found success
                    let newView = UIView.init(frame: CGRectMake(edge1.x, edge1.y, newViewWidth, newViewHeight))
                    if (mainView?.subviews.count)!%2==0 {
                        newView.backgroundColor = UIColor.orangeColor()
                    }
                    else {
                        newView.backgroundColor = UIColor.greenColor()
                    }
                    mainView?.addSubview(newView)
                    
                    path.moveToPoint(edge1)
                    path.addLineToPoint(edge1)
                    path.addLineToPoint(edge2)
                    path.addLineToPoint(edge4)
                    path.addLineToPoint(edge3)
                    path.addLineToPoint(edge1)
                    path.closePath()
                    
                    viewFound = true
                }
            }
            else {
                print("estimated new view is out of main view")
            }
        }
    }
    
    func getRandomPoint () -> CGPoint {

        let randomPoint = CGPointMake(CGFloat(Int.random(0...Int(mainView!.frame.size.width))), CGFloat(Int.random(0...Int(mainView!.frame.size.height))))
        print(randomPoint)
        return randomPoint
    }
}

