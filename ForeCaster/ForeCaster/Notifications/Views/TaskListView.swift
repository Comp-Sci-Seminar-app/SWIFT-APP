import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskManager = TaskManager.shared
    @State var showNotificationSettingsUI = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    //Title
                    Text("Weather Reminders")
                        .font(.title)
                        .foregroundColor(.pink)
                    Spacer()
                    //Get permission for notifications
                    Button(
                        action: {
                            //Puts in the request for notification permission
                            NotificationManager.shared.requestAuthorization { granted in
                                //Shows the notification settings if they're authorized
                                if granted {
                                    showNotificationSettingsUI = true
                                }
                            }
                        },
                        label: {
                            Image(systemName: "bell")
                                .font(.title)
                                .accentColor(.pink)
                        })
                        .padding(.trailing)
                        .sheet(isPresented: $showNotificationSettingsUI) {
                            NotificationSettingsView()
                        }
                }
                .padding()
                if taskManager.tasks.isEmpty {
                    Spacer()
                    Text("No Tasks!")
                        .foregroundColor(.pink)
                        .font(.title3)
                    Spacer()
                } else {
                    List(taskManager.tasks) { task in
                        TaskCell(task: task)
                    }
                    .padding()
                }
            }
            AddTaskView()
        }
    }
}

struct TaskCell: View {
    var task: Task
    
    var body: some View {
        HStack {
            Button(
                action: {
                    TaskManager.shared.markTaskComplete(task: task)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        TaskManager.shared.remove(task: task)
                    }
                }, label: {
                    Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .accentColor(.pink)
                })
            if task.completed {
                Text(task.name)
                    .strikethrough()
                    .foregroundColor(.pink)
            } else {
                Text(task.name)
                    .foregroundColor(.pink)
            }
        }
    }
}


struct AddTaskView: View {
    @State var showCreateTaskView = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                //Add task button
                Button(
                    action: {
                        showCreateTaskView = true
                    }, label: {
                        Text("+")
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.white)
                            .padding()
                    })
                    .background(Color.pink)
                    .cornerRadius(40)
                    .padding()
                    .sheet(isPresented: $showCreateTaskView) {
                        CreateTaskView()
                    }
            }
            .padding(.bottom)
        }
    }
}
