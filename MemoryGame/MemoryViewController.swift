//
//  MemoryViewController.swift
//  MemoryGame
//  The memory game is created to test the users memory by flipping 2 cards at any 2 consequiteive times
//  if the cards are the same then its opened else closed
//  The logic is implemented using the Stack data structure to get the last card added to the stack & compare with the current card
//  Created by Punnaghai Puvi on 4/12/16.
//  Copyright © 2016 Punnaghai Puvi. All rights reserved.
//

import UIKit

class MemoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    
    private let reuseIdentifier = "FlickrCell"
    
    //objects obtained from flickrservice are converted to object array & populated
    var images:[FlickrResults] = [FlickrResults]()
    
    /**the stack that stores the opened cards. the current opened card is checked with the item at the top of the stack for match. if found all the items in the stack are removed. else continues to open the next card.
        The stack holds max of 2 cards. if the count is exceeds all the cards are flipped back & the search starts again
    */
    var stackArray:NSMutableArray = NSMutableArray()
    
    var collectionViewLayout: CustomImageFlowLayout!
    
    /**
     dynamically change the size of the image stack at run time
    */
    var imageSize:String = Size.large.rawValue
    
    /**
        this variable checks for the no of matches found & if found appends the count. 
        if the count reaches the max cell count then message is displayed to the user
    */
    var totalMatchFound:Int = 0
    
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var btnNewGame: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        collectionViewLayout = CustomImageFlowLayout()
        imageCollection.collectionViewLayout = collectionViewLayout
        imageCollection.backgroundColor = .blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadNewGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(imageSize == Size.medium.rawValue){
            return 12
        }else if(imageSize == Size.large.rawValue){
            return 8
        }else{
            return 16
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FlickrImageCell
            cell.userInteractionEnabled = true
            let flickrPhoto:FlickrPhoto = photoForIndexPath(indexPath)
            cell.configure(flickrPhoto)
            cell.backgroundColor = UIColor.blackColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        let selectedCell:FlickrImageCell = collectionView.cellForItemAtIndexPath(indexPath) as! FlickrImageCell
        selectedCell.imageTouched()
        if(stackArray.count == 0){
            stackArray.addObject(selectedCell)
        }else {
            if(stackArray.count<2){
                let contentCell : FlickrImageCell = stackArray.objectAtIndex(stackArray.count-1) as! FlickrImageCell
                if(contentCell.picDetails.photoId != selectedCell.picDetails.photoId){
                    stackArray.addObject(selectedCell)
                }else{
                    contentCell.userInteractionEnabled = false
                    selectedCell.userInteractionEnabled = false
                    stackArray.removeAllObjects()
                    totalMatchFound = totalMatchFound + 2
                    self.checkGameComplete()
                }
            }
            else{
                for i in 0..<stackArray.count {
                    let content:FlickrImageCell = stackArray.objectAtIndex(i) as! FlickrImageCell
                    content.imageTouched()
                }
                stackArray.removeAllObjects()
                stackArray.addObject(selectedCell)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if(imageSize == Size.medium.rawValue){
            return CGSize(width: 100, height: 100)
        }else if(imageSize == Size.large.rawValue){
            return CGSize(width: 150, height: 150)
        }else{
            return CGSize(width: 75, height: 75)
        }
        
    }
    
    @IBAction func newGame_Generate(sender: AnyObject){
        
        statusLabel.hidden = true
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        optionMenu.addAction(UIAlertAction(title: "Small size images", style: UIAlertActionStyle.Default, handler:smallImageAction))
        optionMenu.addAction(UIAlertAction(title: "Medium size images", style: UIAlertActionStyle.Default, handler:mediumImageAction))
        optionMenu.addAction(UIAlertAction(title: "Large size images", style: UIAlertActionStyle.Default, handler:largeImageAction))
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        }))
        self.presentViewController(optionMenu, animated: true, completion: nil)
        return
    }
    
    func smallImageAction(alert: UIAlertAction){
        imageSize = Size.small.rawValue
        self.loadNewGame()
    }
    
    func mediumImageAction(alert: UIAlertAction){
        imageSize = Size.medium.rawValue
        self.loadNewGame()
    }
    
    func largeImageAction(alert: UIAlertAction){
        imageSize = Size.large.rawValue
        self.loadNewGame()
    }
    
    func loadNewGame(){
        stackArray.removeAllObjects()
        totalMatchFound = 0
        FlickrImageService.sharedInstance.fetchImages(imageSize){ (flickrImages, error) -> Void in
            self.images.insert(flickrImages!, atIndex: 0)
            if(self.imageCollection.dataSource != nil || self.imageCollection.delegate == nil){
                self.imageCollection.dataSource = self
                self.imageCollection.delegate = self
            }
            self.imageCollection.reloadData()
        }
    }
    
    func checkGameComplete(){
        
        if(imageSize == Size.medium.rawValue){
            if(totalMatchFound == 12){
                statusLabel.hidden = false
            }
        }else if(imageSize == Size.large.rawValue){
            if(totalMatchFound == 8){
                statusLabel.hidden = false
            }
        }else{
            if(totalMatchFound == 16){
                statusLabel.hidden = false
            }
        }
        
        if(statusLabel.hidden == false){
            let options : UIViewAnimationOptions = [.Repeat, .Autoreverse]
            UIView.animateWithDuration(0.25, delay:0.0, options:options, animations: {
                self.statusLabel.alpha = 0
                }, completion: nil)
        }
        
    }
    
    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto {
        return self.images[indexPath.section].imageCollection[indexPath.row]
    }
    
    
}
