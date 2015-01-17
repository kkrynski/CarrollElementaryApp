//
//  NewsFeed.swift
//  FloraDummy
//
//  Created by Michael Schloss on 11/27/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class BreakingNewsLabel : UILabel
{
    override func drawRect(rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        
        let drawnShadowOffset = CGSizeMake (5.0,  0.0)
        
        CGContextSaveGState(context)
        CGContextSetShadow (context, drawnShadowOffset, 8)
        
        CGContextSetLineWidth(context, 1.0)
        
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        
        CGContextMoveToPoint(context, rect.size.width * 0.2, 0)
        CGContextAddLineToPoint(context, rect.size.width, 0)
        CGContextAddLineToPoint(context, rect.size.width * 0.8, rect.size.height)
        CGContextAddLineToPoint(context, 0, rect.size.height)
        CGContextAddLineToPoint(context, rect.size.width * 0.2, 0)
        
        CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
        CGContextFillPath(context)
        
        CGContextRestoreGState(context)
        
        super.drawRect(rect)
    }
}

protocol NewsFeedDelegate
{
    func showBreakingNewsLabel()
}

class NewsFeed: UIScrollView, MWFeedParserDelegate, UIScrollViewDelegate
{
    private var arrayOfItems = NSMutableArray()
    private var viewsArray = NSMutableArray()
    
    private var feedParser : MWFeedParser?
    
    private var counter = 0
    
    private var color : UIColor?
    
    var newsFeedDelegate : NewsFeedDelegate?
    var shouldMoveToNextItem = YES
    
    init(frame: CGRect, andPrimaryColor primaryColor: UIColor)
    {
        super.init(frame: frame)
        
        color = primaryColor
        delegate = self
        
        let blogFeed = NSURL(string: "http://www.carroll.k12.in.us/carroll-blog/latest?format=feed&type=rss")
        feedParser = MWFeedParser(feedURL: blogFeed)
        feedParser!.delegate = self
        feedParser!.feedParseType = ParseTypeFull
        feedParser!.connectionType = ConnectionTypeAsynchronously;
        feedParser!.parse()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Display Methods
    
    //Starts the feed scrolling
    func startFeed()
    {
        let infoLabel = UILabel()
        infoLabel.font = UIFont(name: "Marker Felt", size: 24)
        infoLabel.textColor = color
        infoLabel.attributedText = getTextForCurrentItem()
        Definitions.outlineTextInLabel(infoLabel)
        infoLabel.sizeToFit()
        
        let logo = UIImageView(image: UIImage(named: "CarrollESLogo.png"))
        logo.contentMode = .ScaleAspectFit
        logo.frame = CGRectMake(0, 0, 102, 40)
        
        let view = UIView(frame: CGRectMake(0, 0, logo.frame.size.width + 8 + infoLabel.frame.size.width + 8, infoLabel.frame.size.height))
        logo.center = CGPointMake(logo.frame.size.width/2.0, view.frame.size.height/2.0)
        view.addSubview(logo)
        infoLabel.center = CGPointMake(logo.frame.size.width + logo.frame.origin.x + 8 + infoLabel.frame.size.width/2.0, view.frame.size.height/2.0)
        view.addSubview(infoLabel)
        
        contentSize = CGSizeMake(view.frame.size.width, 0)
        view.center = CGPointMake(view.frame.size.width/2.0, frame.size.height/2.0)
        addSubview(view)
        
        let oldX = frame.origin.x
        frame = CGRectMake(frame.size.width, frame.origin.y, frame.size.width, frame.size.height)
        
        viewsArray.addObject(view)
        
        UIView.animateWithDuration(15.0, delay: 0.0, options: .AllowAnimatedContent | .CurveLinear, animations:{ () -> Void in
            
            self.frame = CGRectMake(oldX, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
            
            }, completion: { (finished) -> Void in
                
                self.counter++
                self.counter = self.counter % self.arrayOfItems.count
                if self.shouldMoveToNextItem
                {
                    self.scrollNextItem()
                }
        })
    }
    
    //Moves onto every item after first one
    func scrollNextItem()
    {
        let infoLabel = UILabel()
        infoLabel.font = UIFont(name: "Marker Felt", size: 24)
        infoLabel.textColor = color
        infoLabel.attributedText = getTextForCurrentItem()
        Definitions.outlineTextInLabel(infoLabel)
        infoLabel.sizeToFit()
        
        let logo = UIImageView(image: UIImage(named: "CarrollESLogo.png"))
        logo.contentMode = .ScaleAspectFit
        logo.frame = CGRectMake(0, 0, 102, 40)
        
        let view = UIView(frame: CGRectMake(0, 0, logo.frame.size.width + 8 + infoLabel.frame.size.width + 8, infoLabel.frame.size.height))
        view.layer.shouldRasterize = YES
        view.layer.rasterizationScale = UIScreen.mainScreen().scale
        logo.center = CGPointMake(logo.frame.size.width/2.0, view.frame.size.height/2.0)
        view.addSubview(logo)
        infoLabel.center = CGPointMake(8 + logo.frame.size.width + infoLabel.frame.size.width/2.0, view.frame.size.height/2.0)
        view.addSubview(infoLabel)
        
        let oldView = self.viewsArray.firstObject as UIView
        view.center = CGPointMake(oldView.frame.origin.x + oldView.frame.size.width + 8 + view.frame.size.width/2.0, frame.size.height/2.0)
        addSubview(view)
        
        viewsArray.addObject(view)
        
        UIView.animateWithDuration(15.0, delay: 0.0, options: .AllowAnimatedContent | .CurveLinear, animations:{ () -> Void in
            
            self.contentOffset = CGPointMake(view.frame.size.width, 0)
            
            }, completion: { (finished) -> Void in
                
                let oldView = self.viewsArray.firstObject as UIView
                oldView.removeFromSuperview()
                self.viewsArray.removeObject(oldView)
                
                self.contentOffset = CGPointMake(0, 0)
                view.center = CGPointMake(view.center.x - view.frame.size.width, view.center.y)
                
                self.counter++
                self.counter = self.counter % self.arrayOfItems.count
                if self.shouldMoveToNextItem
                {
                    self.scrollNextItem()
                }
        })
    }
    
    //Creates the text to display in the label
    private func getTextForCurrentItem() -> NSMutableAttributedString
    {
        let currentItem = arrayOfItems.objectAtIndex(counter) as MWFeedItem
        
        let mutableText = NSMutableAttributedString()
        mutableText.insertAttributedString(NSAttributedString(string: currentItem.title, attributes: NSDictionary(objectsAndKeys: UIFont(name: "MarkerFelt-Wide", size: 28)!, NSFontAttributeName)), atIndex: mutableText.length)
        mutableText.insertAttributedString(NSAttributedString(string: ": "), atIndex: mutableText.length)
        mutableText.insertAttributedString(NSAttributedString(string: stringByStrippingHTML(currentItem.summary)), atIndex: mutableText.length)
        
        return mutableText
    }
    
    //Strips all HTML code out of the summary XML string
    private func stringByStrippingHTML(string: NSString) -> String
    {
        var newString = string
        
        while newString.rangeOfString("<[^>]+>", options: .RegularExpressionSearch).location != NSNotFound
        {
            newString = newString.stringByReplacingCharactersInRange(newString.rangeOfString("<[^>]+>", options: .RegularExpressionSearch), withString: "")
        }
        
        var counter = 0
        var returnString = ""
        
        newString.enumerateSubstringsInRange(NSMakeRange(0, newString.length), options: .ByWords) { (word, range, newRange, stop) -> Void in
            counter++
            if counter <= 15
            {
                returnString += word + " "
            }
        }
        
        return ((returnString as NSString).stringByReplacingOccurrencesOfString(" nbsp ", withString: ".  ") as NSString).stringByReplacingOccurrencesOfString("Read More", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " ")).stringByAppendingString("...")
    }
    
    //MARK: - Animation Pausing and Resuming
    
    func pauseAnimations()
    {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeAnimations()
    {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    //MARK: - Feed Parser Delegate Methods
    
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!)
    {
        for object : AnyObject in arrayOfItems
        {
            let feedItem = object as MWFeedItem
            
            if feedItem.identifier == item.identifier
            {
                arrayOfItems.replaceObjectAtIndex(arrayOfItems.indexOfObject(object), withObject: item)
            }
        }
        
        arrayOfItems.addObject(item)
    }
    
    func feedParserDidFinish(parser: MWFeedParser!)
    {
        newsFeedDelegate?.showBreakingNewsLabel()
    }
    
    func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!)
    {
        arrayOfItems = NSMutableArray()
        NSTimer.scheduledTimerWithTimeInterval(60.0, target: feedParser!, selector: "parse", userInfo: nil, repeats: NO)
    }
    
    
}
