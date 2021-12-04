//
//  Animator.swift
//  Animation(TabBar)
//
//  Created by Mehmet fatih DOĞAN on 19.07.2021.
//

import UIKit

public class Animator {

    public static let sharedInstance = Animator()
    var transpranView = UIImageView()
    var indicator = UIActivityIndicatorView()

    private init(){
        transpranView.frame = UIScreen.main.bounds
        transpranView.backgroundColor = UIColor.black
        transpranView.isUserInteractionEnabled = true
        transpranView.alpha = 0.5
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = transpranView.center
        indicator.startAnimating()
        indicator.color = .systemTeal
        
        
    }

    
    func showAnimation(){
        DispatchQueue.main.async{
            appContainer.router.window?.addSubview(self.transpranView)
            appContainer.router.window?.addSubview(self.indicator)
           
        }
    }
    func hideAnimation(){

        DispatchQueue.main.async( execute:
            {
                self.transpranView.removeFromSuperview()
                self.indicator.removeFromSuperview()
        })
    }
}
