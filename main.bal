import ballerina/http;

listener http:Listener httpDefaultListener = http:getDefaultListener();

type Todo record {
    readonly int id;
    string title;
    boolean completed;
};

table<Todo> key(id) tasks = table [
    { id: 0, title: "Task 0: Participate Hackathon", completed: true},
    { id: 1, title: "Task 1: Learn Ballerina", completed: true },
    { id: 2, title: "Task 2: Test Ballerina", completed: false },
    { id: 3, title: "Task 3: Think new solutions to problems", completed: false },
    { id: 4, title: "Task 4: Write Ballerina code", completed: false },
    { id: 5, title: "Task 5: Deploy Ballerina application", completed: false }
];

service / on httpDefaultListener {

    // get all todos
    resource function get todos() returns error|json|http:InternalServerError| Todo[] {
        do {
            return tasks.toArray();

        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

    // get todo by id
    resource function get todo/[int id]() returns Todo|error|http:InternalServerError{

        do {
            Todo? todo = tasks.get(id);
                if todo is Todo{
                    return todo;
                } else{
                    return error("Todo not found with id: " + id.toString());
                }
        } on fail error err {
            // handle error
            return error("unhandled error", err);       
        }
    }
}