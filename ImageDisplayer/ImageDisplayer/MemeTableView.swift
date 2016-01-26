//
//  MemeTableView.swift
//  ImageDisplayer
//
//  Created by Jonathan Matusky on 1/26/16.
//  Copyright © 2016 Jonathan Matusky. All rights reserved.
//

import Foundation
import UIKit

class MemeTableView: UITableViewController {
    
    var memeCollection: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memeCollection = applicationDelegate.memes
        print(self.memeCollection.count)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memeCollection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")!
        let meme = self.memeCollection[indexPath.row]
        cell.imageView?.image = meme.memeImage
        cell.textLabel?.text = meme.memeTopText
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let meme = self.memeCollection[indexPath.row]
        let memeView = self.storyboard?.instantiateViewControllerWithIdentifier("memeViewer") as! ViewController
        memeView.topString = meme.memeTopText
        memeView.bottomString = meme.memeBottomText
        memeView.image = meme.memeOriginalImage
        self.navigationController?.pushViewController(memeView, animated: true)
    }
}