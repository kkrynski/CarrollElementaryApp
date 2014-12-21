//
//  HomeVC.swift
//  Flora Dummy
//
//  Created by Michael Schloss on 10/25/14.
//  Copyright (c) 2014 SGSC. All rights reserved.
//

import UIKit

class HomeVC: FormattedVC, NewsFeedDelegate
{
    //Elements on screen
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var homeImageView : UIImageView?
    @IBOutlet var weatherView : WeatherView?
    
    private var newsFeed : NewsFeed?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tabBarController?.tabBar.tintColor = .whiteColor()
        tabBarController!.tabBar.barStyle = .Black
        
        newsFeed = NewsFeed(frame: CGRectMake(0, 0, view.frame.size.width, 40), andPrimaryColor: primaryColor)
        newsFeed!.newsFeedDelegate = self
        newsFeed!.center = CGPointMake(view.frame.size.width/2.0, view.frame.size.height - self.bottomLayoutGuide.length - newsFeed!.frame.size.height/2.0)
        view.addSubview(newsFeed!)
    }
    
    //Set the colors here for instant loading
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.tintColor = .whiteColor()
        tabBarController?.tabBar.barStyle = .Black
        
        weatherView?.player?.play()
        
        titleLabel!.textColor = primaryColor
        Definitions.outlineTextInLabel(titleLabel!)
        
        view.backgroundColor = backgroundColor
        
        weatherView!.updateColors(primaryColor)
        
        newsFeed!.center = CGPointMake(view.frame.size.width/2.0, view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - newsFeed!.frame.size.height/2.0 - 11)
        
        if newsFeed!.shouldMoveToNextItem == NO
        {
            newsFeed!.scrollNextItem()
            newsFeed!.shouldMoveToNextItem = YES
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        newsFeed!.shouldMoveToNextItem = NO
        
        tabBarController?.tabBar.tintColor = UIApplication.sharedApplication().keyWindow?.tintColor
        tabBarController?.tabBar.barStyle = .Default
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        weatherView!.player!.pause()
    }
    
    //MARK: - News Feed Delegate
    
    func showBreakingNewsLabel()
    {
        let breakingNewsLabel = BreakingNewsLabel(frame: CGRectMake(0, 0, 150, 60))
        breakingNewsLabel.textAlignment = .Center
        breakingNewsLabel.text = "News"
        breakingNewsLabel.textColor = primaryColor
        breakingNewsLabel.font = UIFont(name: "Marker Felt", size: 22)
        breakingNewsLabel.numberOfLines = 0
        breakingNewsLabel.center = CGPointMake(view.frame.size.width + breakingNewsLabel.frame.size.width/2.0, newsFeed!.center.y)
        breakingNewsLabel.layer.shouldRasterize = YES
        breakingNewsLabel.layer.rasterizationScale = UIScreen.mainScreen().scale
        breakingNewsLabel.layer.shadowOpacity = 1.0
        breakingNewsLabel.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        Definitions.outlineTextInLabel(breakingNewsLabel)
        view.addSubview(breakingNewsLabel)
        
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: .AllowAnimatedContent, animations: { () -> Void in
            
            breakingNewsLabel.center = CGPointMake(breakingNewsLabel.frame.size.width * 0.3, breakingNewsLabel.center.y)
            
            }, completion: { (finished) -> Void in
            self.newsFeed!.startFeed()
        })
    }
}
