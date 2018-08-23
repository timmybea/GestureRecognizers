//
//  ViewController.swift
//  GestureRecognizers
//
//  Created by Tim Beals on 2018-08-23.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var document: UIImageView = {
        let iv = UIImageView(image: UIImage(named: UIImage.imageName.document)!)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    var documentOrigin : CGPoint? = nil
    
    lazy var trashCan: UIImageView = {
        let iv = UIImageView(image: UIImage(named: UIImage.imageName.trashCan)!)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.darkGray

    }

    override func viewWillAppear(_ animated: Bool) {

        document.removeFromSuperview()
        trashCan.removeFromSuperview()
        
        //setup views in order: back to front
        view.addSubview(trashCan)
        NSLayoutConstraint.activate([
            trashCan.heightAnchor.constraint(equalToConstant: 60),
            trashCan.widthAnchor.constraint(equalToConstant: 60),
            trashCan.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            trashCan.rightAnchor.constraint(equalTo: view.rightAnchor, constant:-20)
            ])
        
        view.addSubview(document)
        NSLayoutConstraint.activate([
            document.heightAnchor.constraint(equalToConstant: 60),
            document.widthAnchor.constraint(equalToConstant: 60),
            document.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            document.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
            ])
        
        addPanGestureRecognizer(to: document, action: #selector(handleDocumentPan(sender:)))

    }
    
}

//MARK: Gesture Recognizer methods.
extension ViewController {
    
    func addPanGestureRecognizer(to view: UIView, action: Selector) {
    
        let panGesture = UIPanGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handleDocumentPan(sender: UIPanGestureRecognizer) {
        guard let view = sender.view else { return }
        
        switch sender.state {
            
        case .began:
            
            documentOrigin = documentOrigin ?? view.frame.origin
            
        case .changed:
            
            moveView(view, with: sender)
        
        case .ended:
            
            if trashCan.frame.intersects(document.frame) {
                
                disappearAnimation(document)
                
                returnView(document, to: documentOrigin!)
                
                appearAnimation(document)
                
            } else {
                
                returnView(document, to: documentOrigin!)
                
            }
            
        default:
            break
        }
    }
    
    private func pointWithinBounds(point: inout CGPoint) {
        
        if point.y < 40 {
            point.y = 40
        }
        
        if point.x < 40 {
            point.x = 40
        }
        
        if point.x > view.bounds.maxX - 40 {
            point.x = view.bounds.maxX - 40
        }
        
        if point.y > view.bounds.maxY - 40 {
            point.y = view.bounds.maxY - 40
        }
    }
    
    private func moveView(_ view: UIView, with panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: self.view)
        var point = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        pointWithinBounds(point: &point)
        view.center = point
        panGesture.setTranslation(CGPoint.zero, in: self.view)
        
    }
    
    private func disappearAnimation(_ view: UIView) {
        
        UIView.animate(withDuration: 0.3) {
            view.alpha = 0
        }
        
    }

    private func appearAnimation(_ view: UIView) {
        
        UIView.animate(withDuration: 0.3) {
            self.document.alpha = 1.0
        }
        
    }
    
    private func returnView(_ view: UIView, to origin: CGPoint) {
        
        view.frame.origin = origin
    
    }
}



