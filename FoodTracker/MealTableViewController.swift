//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Vincent on 9/3/17.
//
//

import os.log
import UIKit

class MealTableViewController: UITableViewController {
    
    // MARK: - Properties
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load saved meals if there are any, otherwise load sample meals
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            loadSampleMeals()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Only one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table cells arereused and should be dequeued using a cell identifier
        let cellIdentifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? MealTableViewCell else {
                fatalError("Dequeued cell not an instance of MealTableViewCell")
        }
        
        // Fetch appropriate meal fro data source layout
        let meal = meals[indexPath.row]

        // Configure the cell
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
            case "AddItem":
                if #available(iOS 10.0, *) {
                    os_log("Adding a new meal.", log: OSLog.default, type: .debug)
                }
            case "ShowDetail":
                guard let mealDetailViewController = segue.destination as? MealViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                guard let selectedMealCell = sender as? MealTableViewCell else {
                    fatalError("Unexpected sender: \(sender ?? "unknown")")
                }
                guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                    fatalError("The selected sell is not displayed in the table")
                }
            
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "unknown")")
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new meal
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            saveMeals()
        }
    }
    
    // MARK: - Private Methods
    private func loadSampleMeals() {
        let photoApple = UIImage(named: "SampleApples")
        let photoNoodles = UIImage(named: "SampleNoodles")
        let photoPasta = UIImage(named: "SamplePasta")
        let photoPotatoes = UIImage(named: "SamplePotatoes")
        
        guard let mealApples = Meal(name: "Apples", photo: photoApple, rating: 4) else {
            fatalError("Unable to instantiate mealApples")
        }
        
        guard let mealNoodles = Meal(name: "Noodles", photo: photoNoodles, rating: 5) else {
            fatalError("Unable to instantiate mealNoodles")
        }
        
        guard let mealPasta = Meal(name: "Pasta", photo: photoPasta, rating: 3) else {
            fatalError("Unable to instantiate mealPasta")
        }
        
        guard let mealPotatoes = Meal(name: "Potatoes", photo: photoPotatoes, rating: 5) else {
            fatalError("Unable to instantiate mealPotatoes")
        }
        
        meals += [mealApples, mealNoodles, mealPasta, mealPotatoes]
    }
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            if #available(iOS 10.0, *) {
                os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
            }
        } else {
            if #available(iOS 10.0, *) {
                os_log("Failed to save meals.", log: OSLog.default, type: .error)
            }
        }
    }

    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    
}
