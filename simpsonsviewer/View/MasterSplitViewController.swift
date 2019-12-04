//
//  MasterSplitViewController.swift
//  simpsonsviewer
//
//  Created by Jorge Encinas on 04/12/19.
//  Copyright © 2019 Jorge Encinas. All rights reserved.
//

import UIKit

class MasterSplitViewController: UISplitViewController, UISplitViewControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .allVisible
        // Do any additional setup after loading the view.
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
          return true
      }

}
