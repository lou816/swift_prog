//
//  FrontPageTableViewController.swift
//  Topic
//
//  Created by 詹禾稑 on 2021/11/22.
//

import UIKit

import CoreData

class FrontPageTableViewController: UITableViewController {

    enum Section {
        case picture
    }
    
    var pictures:[Picture] = []
    var fetchResultController: NSFetchedResultsController<Picture>!
    
    override func viewDidAppear(_ animated: Bool) {

//        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
//            return
//        }

        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            present(walkthroughViewController, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPictureData()
        tableView.dataSource = dataSource
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    

    
    lazy var dataSource = configureDataSource()
    
    // MARK: - Table view data source

    func configureDataSource() -> UITableViewDiffableDataSource<Section, Picture> {
        
        let cellIdentifier = "picturecell"
        
        let dataSource = UITableViewDiffableDataSource<Section, Picture>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, picture in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PictureTableViewCell
                
                cell.nameLabel.text = picture.name
                cell.pictureImageView.image = UIImage(data: picture.image)
                
                return cell
            }
        )
        return dataSource
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paintingPicture" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! PaintingViewController

                destinationController.basePicture = UIImage(data: pictures[indexPath.row].image)
                destinationController.pictureIndex = indexPath.row
                destinationController.pictureImages = pictures[indexPath.row].name
            }
        }
    }
    
    func fetchPictureData() {
    // 從資料儲存器取得資料
        let fetchRequest: NSFetchRequest<Picture> = Picture.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                updateSnapshot()
            } catch {
                print(error)
            }
        }
    }
    
    func updateSnapshot(animatingChange: Bool = false) {
        if let fetchedObjects = fetchResultController.fetchedObjects {
            pictures = fetchedObjects
        }
        // 建立一個快照並填入資料
        var snapshot = NSDiffableDataSourceSnapshot<Section, Picture>()
        snapshot.appendSections([.picture])
        snapshot.appendItems(pictures, toSection: .picture)
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
}


extension FrontPageTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
}
