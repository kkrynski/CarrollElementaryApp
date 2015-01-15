//
//  SquaresDragAndDrop.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/30/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class SquaresDragAndDrop: PageVC
{
    /**
    The number of squares to place on the screen.
    
    These squares will be placed randomly around the page.
    */
    var numberOfSquares : Int = 0
    
    private var squareSize = CGSizeMake(60, 60)
    
    private var dynamicAnimator : UIDynamicAnimator?
    private var snapBehavior : UISnapBehavior?
    
    private var arrayOfCoordinates = Array<(x: Int, y: Int)>()
    private var arrayOfSquares = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        for index in 0...(numberOfSquares - 1)
        {
            let square = UIView(frame: CGRectMake(0, 0, squareSize.width, squareSize.height))
            square.backgroundColor = Definitions.randomColor()
            let center = coordiantesForSize((Int(squareSize.width), Int(squareSize.height)))
            square.center = CGPointMake(CGFloat(center.x), CGFloat(center.y))
            view.addSubview(square)
            arrayOfSquares.addObject(square)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: "panSquare:")
            square.addGestureRecognizer(panGesture)
            
        }
        addCollisionBehavior()
    }
    
    
    func panSquare(panGesture : UIPanGestureRecognizer)
    {
        let square = panGesture.view
        view.bringSubviewToFront(square!)
        
        switch panGesture.state
        {
        case .Began:
            dynamicAnimator!.removeAllBehaviors()
            addCollisionBehavior()
            
            for object in arrayOfSquares
            {
                let objectSquare = object as UIView
                
                if objectSquare != square
                {
                    let snap = UISnapBehavior(item: objectSquare, snapToPoint: objectSquare.center)
                    dynamicAnimator!.addBehavior(snap)
                }
            }
            
            if snapBehavior != nil
            {
                dynamicAnimator!.removeBehavior(snapBehavior!)
            }
            snapBehavior = UISnapBehavior(item: square!, snapToPoint: panGesture.locationInView(view))
            dynamicAnimator!.addBehavior(snapBehavior)
            
        case .Changed:
            if snapBehavior != nil
            {
                dynamicAnimator!.removeBehavior(snapBehavior!)
            }
            snapBehavior = UISnapBehavior(item: square!, snapToPoint: panGesture.locationInView(view))
            dynamicAnimator!.addBehavior(snapBehavior)
            break
            
        default:
            break
        }
    }
    
    //MARK: - Private Functions
    
    private func addCollisionBehavior()
    {
        let collisionBehavior = UICollisionBehavior(items: arrayOfSquares)
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0))
        //collisionBehavior.addBoundaryWithIdentifier("nextLabel", forPath: UIBezierPath(rect: nextButton.frame))
        //collisionBehavior.addBoundaryWithIdentifier("pageLabel", forPath: UIBezierPath(rect: otherLabel.frame))
        
        dynamicAnimator!.addBehavior(collisionBehavior)
    }
    
    private func coordiantesForSize(size: (width: Int, height: Int)) -> (x: Int, y: Int)
    {
        var x : Int
        var y : Int
        
        do
        {
            x = Int(arc4random_uniform(UInt32(view.bounds.size.width)))
            y = Int(arc4random_uniform(UInt32(view.bounds.size.height)))
        }
        while pointIsInvalid((x, y), withSize: size)
        
        arrayOfCoordinates.insert((x, y), atIndex: arrayOfCoordinates.count)
        
        return (x, y)
    }
    
    private func pointIsInvalid(point: (x: Int, y: Int), withSize size: (width: Int, height: Int)) -> Bool
    {
        let pointIsOutOfXBounds = (point.x < size.width/2 + 20 || point.x > Int(view.bounds.size.width) - size.width/2 - 20)
        let pointIsOutOfYBounds = (point.y < size.height/2 + 20 || point.y > Int(view.bounds.size.height) - size.height/2 - 20)
        
        if pointIsOutOfXBounds || pointIsOutOfYBounds /*|| CGRectContainsRect(CGRectInset(otherLabel.frame, -8.0, -8.0), CGRectMake(CGFloat(point.x), CGFloat(point.y), CGFloat(size.width), CGFloat(size.height))) || CGRectContainsRect(CGRectInset(nextButton.frame, -8.0, -8.0), CGRectMake(CGFloat(point.x), CGFloat(point.y), CGFloat(size.width), CGFloat(size.height)))*/
        {
            return YES
        }
        
        for arrayPoint in arrayOfCoordinates
        {
            if  ((point.x < arrayPoint.x + size.width && point.x > arrayPoint.x - size.width) &&
                (point.y < arrayPoint.y + size.height && point.y > arrayPoint.y - size.height))
            {
                return YES
            }
        }
        return NO
    }
}
