//
//  MemeCollectionView.swift
//  ImageDisplayer
//
//  Created by Jonathan Matusky on 1/26/16.
//  Copyright © 2016 Jonathan Matusky. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionView: UICollectionViewController {
    
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!
    
    var memeCollection: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memeCollection = applicationDelegate.memes
        print(self.memeCollection.count)
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowlayout.minimumInteritemSpacing = space
        flowlayout.minimumLineSpacing = space
        flowlayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memeCollection.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCell", forIndexPath: indexPath) as! CustomMemeCell
        let meme = self.memeCollection[indexPath.row]
        cell.memeImage.image = meme.memeImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let meme = self.memeCollection[indexPath.row]
        let memeView = self.storyboard?.instantiateViewControllerWithIdentifier("memeViewer") as! ViewController
        memeView.topString = meme.memeTopText
        memeView.bottomString = meme.memeBottomText
        memeView.image = meme.memeOriginalImage
        self.navigationController?.pushViewController(memeView, animated: true)
    }
}