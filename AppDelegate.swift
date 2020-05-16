//
//  AppDelegate.swift
//  MAD_Assignment2
//
//  Created by ychuang on 24/10/18.
//  Copyright © 2018 ychuang. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MAD_Assignment2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //------------ My Code --------------
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    // --- STUDENT--- Start
    func addStudentInfo(sId: String, firstName: String, lastName: String, gender: String,
                          courseStudy: String, age: Int, address: String) {
        
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "Student", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        transc.setValue(sId, forKey: "studentId")
        transc.setValue(firstName, forKey: "firstName")
        transc.setValue(lastName, forKey: "lastName")
        transc.setValue(gender, forKey: "gender")
        transc.setValue(courseStudy, forKey: "courseStudy")
        transc.setValue(age, forKey: "age")
        transc.setValue(address, forKey: "address")
        
        do{
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func getStudentList() -> (sIds: [String], sNames: [String]) {
        var ids: [String] = []
        var names: [String] = []
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        do{
            let searchResults = try getContext().fetch(fetchRequest)
            
            print("num of results = \(searchResults.count)")
            
            for trans in searchResults as [NSManagedObject] {
                let sId = trans.value(forKey: "studentId") as! String
                let firstName = trans.value(forKey: "firstName") as! String
                //let lastName = trans.value(forKey: "price") as! NSDecimalNumber).stringValue
                let lastName = trans.value(forKey: "lastName") as! String
                
                ids.append(sId)
                names.append(firstName + " " + lastName)
            }
        } catch {
            print("Error with request: \(error)")
        }
        return (ids, names);
    }
    
    func getAStudent(studentId : String) -> Student? {
        // get the student
        let fetchRequest : NSFetchRequest<Student> = Student.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "studentId == %@", studentId)
        do {
            // get the result
            let fetchResult = try getContext().fetch(fetchRequest)
            return fetchResult.first
            
        } catch let error as NSError {
            print("Could not get student \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func updateStudentInfo(studentInfo : Student) {
        let context = getContext()
        
        // get the student
        let recore = getAStudent(studentId: studentInfo.studentId!)

        do {
            recore?.setValue(studentInfo.studentId, forKey: "studentId")
            recore?.setValue(studentInfo.firstName, forKey: "firstName")
            recore?.setValue(studentInfo.lastName, forKey: "lastName")
            recore?.setValue(studentInfo.gender, forKey: "gender")
            recore?.setValue(studentInfo.courseStudy, forKey: "courseStudy")
            recore?.setValue(studentInfo.age, forKey: "age")
            recore?.setValue(studentInfo.address, forKey: "address")
            
            try context.save()
            print("saved!")

        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deleteStudentRecord(student : Student) {
        let context = getContext()
        
        // delete the record
        context.delete(student)
        do{
            try context.save()
        } catch {
            print ("There was an error when deleting a student record")
        }
    }
    // --- STUDENT --- End
    
    // --- EXAM --- Start
    func addExam(sId: String, unitName: String, dateTime: Date, location: String) {
        
        let context = getContext()
    
        let entity = NSEntityDescription.entity(forEntityName: "Exam", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)

        transc.setValue(unitName, forKey: "unitName")
        transc.setValue(location, forKey: "examLocation")
        transc.setValue(dateTime, forKey: "examDateTime")
        
        let student = getAStudent(studentId: sId)
        transc.setValue(student, forKey: "student")
        student?.mutableSetValue(forKey: "exams").add(transc)
        
        do{
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func getExamList(sId : String) -> [Exam]? {

        let fetchRequest: NSFetchRequest<Exam> = Exam.fetchRequest()

        do{
            let searchResults = try getContext().fetch(fetchRequest) as [Exam]
            // filter the result
            if !sId.isEmpty {
                var studentExam = [Exam]()
                for e in searchResults {
                    if e.student?.studentId == sId {
                        studentExam.append(e)
                    }
                }

                print("num of student's exams = \(studentExam.count)")
                return studentExam

            }
            else {
                print("num of all exams = \(searchResults.count)")
                return searchResults
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        return nil
    }
    
    // --- EXAM --- End
    func deleteObject(object : NSManagedObject) {
        let context = getContext()
        context.delete(object)
        do {
            try context.save()
            print("delete object!")
            
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
    }

}

