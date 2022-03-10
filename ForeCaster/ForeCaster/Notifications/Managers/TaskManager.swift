import Foundation

class TaskManager: ObservableObject {
    static let shared = TaskManager()
    let taskPersistenceManager = TaskPersistenceManager()
    
    @Published var tasks: [Task] = []
    
    init() {
        loadTasks()
    }
    
    func save(task: Task) {
        tasks.append(task)
        DispatchQueue.global().async {
            self.taskPersistenceManager.save(tasks: self.tasks)
        }
        //Creates the reminder if the reminder switch is set to true
        if task.reminderEnabled {
            NotificationManager.shared.scheduleNotification(task: task)
        }
    }
    
    func loadTasks() {
        self.tasks = taskPersistenceManager.loadTasks()
    }
    
    func addNewTask(_ taskName: String, _ reminder: Reminder?) {
        if let reminder = reminder {
            save(task: Task(name: taskName, reminderEnabled: true, reminder: reminder))
        } else {
            save(task: Task(name: taskName, reminderEnabled: false, reminder: Reminder()))
        }
    }
    
    func remove(task: Task) {
        tasks.removeAll {
            $0.id == task.id
        }
        DispatchQueue.global().async {
            self.taskPersistenceManager.save(tasks: self.tasks)
        }
        //Removes scheduled notifications once task is done
        if task.reminderEnabled {
            NotificationManager.shared.removeScheduledNotification(task: task)
        }
    }
    
    func markTaskComplete(task: Task) {
        if let row = tasks.firstIndex(where: { $0.id == task.id }) {
            var updatedTask = task
            updatedTask.completed = true
            tasks[row] = updatedTask
        }
    }
}
