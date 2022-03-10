import Foundation

class TaskPersistenceManager {
    enum FileConstants {
        static let tasksFileName = "tasks.json"
    }
    
    func save(tasks: [Task]) {
        do {
            let documentsDirectory = getDocumentsDirectory()
            let storageUrl = documentsDirectory.appendingPathComponent(FileConstants.tasksFileName)
            let tasksData = try JSONEncoder().encode(tasks)
            do {
                try tasksData.write(to: storageUrl)
            } catch {
                print("Couldn't write to File Storage")
            }
        } catch {
            print("Couldn't encode tasks data")
        }
    }
    
    func loadTasks() -> [Task] {
        let documentsDirectory = getDocumentsDirectory()
        let storageUrl = documentsDirectory.appendingPathComponent(FileConstants.tasksFileName)
        guard
            let taskData = try? Data(contentsOf: storageUrl),
            let tasks = try? JSONDecoder().decode([Task].self, from: taskData)
        else {
            return []
        }
        
        return tasks
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
