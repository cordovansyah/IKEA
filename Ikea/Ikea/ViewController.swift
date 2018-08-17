//
//  ViewController.swift
//  Ikea
//
//  Created by octagon studio on 24/07/18.
//  Copyright © 2018 Cordova. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    
    let ikeaItems: [String] = ["gelas", "vas", "gym", "meja"]
    
    var ikeaCVLayout: UICollectionViewFlowLayout =  UICollectionViewFlowLayout.init()
    var myCell = UICollectionViewCell()
    var ikeaCV:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var cellTitle = UILabel()
    
    var selectedItem: String?
    
    
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.session.run(configuration)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.registerUserGesture()
        self.sceneView.delegate = self
        
        menu()
        
    }
    
    func registerUserGesture(){
        let userGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.sceneView.addGestureRecognizer(userGesture)
    }
    
    @objc func tap(sender: UITapGestureRecognizer){
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        if !hitTest.isEmpty {
            self.addItem(hitTestResult: hitTest.first!)
            
        }
    }
    
    func addItem(hitTestResult: ARHitTestResult){
        if let selectedItem = self.selectedItem {
            let scene = SCNScene(named: "Models.scnassets/\(selectedItem).scn")
            let node = (scene?.rootNode.childNode(withName: selectedItem, recursively: false))!
            let transform = hitTestResult.worldTransform
            let thirdColumn = transform.columns.3
            node.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    //COLLECTION VIEW
    
    func menu(){
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        
        ikeaCVLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        ikeaCVLayout.minimumLineSpacing = 1
        ikeaCVLayout.itemSize = CGSize(width: 110, height: 75)
        ikeaCVLayout.scrollDirection = .horizontal
        
        
        ikeaCV = UICollectionView(frame: CGRect(x: 15, y: 580, width: 350, height: 75), collectionViewLayout: ikeaCVLayout)
        ikeaCV.isUserInteractionEnabled = true
        ikeaCV.dataSource = self
        ikeaCV.delegate = self
        ikeaCV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        ikeaCV.backgroundColor = .clear
        ikeaCV.layer.borderWidth = 1.0
        ikeaCV.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        ikeaCV.layer.cornerRadius = cornerRadius
        self.view.addSubview(ikeaCV)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ikeaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        
        cellTitle = UILabel(frame: CGRect(x: -10, y: 12, width: myCell.bounds.size.width, height: 40))
        cellTitle.text = self.ikeaItems[indexPath.row]
        cellTitle.textAlignment = .center
        cellTitle.textColor = UIColor.white
        myCell.contentView.addSubview(cellTitle)
        myCell.backgroundColor = .clear
        
        
        
        
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.selectedItem = ikeaItems[indexPath.row]
        cell?.backgroundColor = UIColor.darkGray
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .clear
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
    }
    
    
    
}



extension Int {
    
    var degreesToRadians: Double { return Double(self) * .pi/180}
}

