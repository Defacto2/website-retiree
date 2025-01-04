> [!WARNING]
> This documentation is retired and maybe inaccurate.

# Lucee programming cheatsheet

## Scopes

### Global

| Scope             | Description                                                                        |
| ----------------- | ---------------------------------------------------------------------------------- |
| **`application`** | Holds elements that relate to the application as a whole.                          |
| `client`          | Contains elements that persist indefinitely for this particular client browser.    |
| `server`          | Used to store data that is accessible from any application on a particular server. |
| `session`         | Holds data pertaining to the user's session.                                       |

### Request

Scopes that persist through the life of a single request.

| Scope         | Description                            |
| ------------- | -------------------------------------- |
| `url`         | HTML POST and form data.               |
| `cgi`         | Lucee web server variables.            |
| **`request`** | Web application (Defacto2) data store. |
| `url`         | URL query string values.               |

### Local

| Scope           | Description                                                                                            |
| --------------- | ------------------------------------------------------------------------------------------------------ |
| `arguments`     | Holds arguments that are passed to a function or CFC method.                                           |
| `this`          | Exists in components or functions.                                                                     |
| `thread`        | Exists within CFML threads.                                                                            |
| **`variables`** | Default scope for variables.<br>Available to the page which it is created and any included (sub)pages. |

### Lucee (official) using scopes

1. Scope everything BUT the closest scope
2. in Functions, local scope (contained within the function)
3. in Templates, variables scope (shared between page and sub-pages)

### Keywords

* `var` sets the variable scope to local.
* `local` scopes to local, but should only be used for reading and not writting variables.
* `variables` scopes variable to the page (.cfm) or component (.cfc)
* `this` scopes variable to be accessible from outside of the component.

1) The variables scope is global to a single component.
2) Any variables without the `var` keyword default to the variables scope.
3) Variables should always be explicity scoped for readability and to prevent mistakes.

+ Any variable instantiated within a function with the `var` keyword, lives in the local scope of that function.


### Examples

```js
<cfscript>
    var string = "a" // local

    // share between subpages and functions
    string = "b" // recommended
    local.string = "c"

    // different scope
    variables.string = "odd"

    honk()

    echo(xx) // error
    echo(new) // new scope

    function honk(){
        var xx = "local scope"
        new = "new scope"
        echo(xx)
        echo(string) // c
        string = "edit scope"
        echo(string) // edit scope
        echo(local.string) // error
        echo(variables.string) // error
    }
</cfscript>
```

```js
component {

    this.outside = "" // public variable shared outside of the component

    public this.outside = ""  // public variable shared outside of the component
    private this.inside = ""  private variable used only within the component

    variables.string = "" // private to the this component
    local.string = "" // private to component
    var string = "" // private to this component
    string = "" // recommended way private to this component

    compString = ""

    function example(string text) {
        var string = "" // set local scope overwriting any outside scope sharing same variable name.
        local.string = "" // set local scope to avoid overwriting outside scopes using the same variable name.
        exampleString = "" // recommended way to set local scope with unique variable names.

        dump(arguments.text) // get local argument
        dump(string) // get local scope
        dump(exampleString) // get local scope

        dump(compString) // get component private variable
        dump(variables.string) // get component private variable

        dump(this.outside) // get component public variable
    }

    for (var index in collection) { // local scope to the loop
        echo(index) // get local scope
    }

}

echo(outside)
```

### [Lucee Scopes](https://docs.lucee.org/guides/developing-with-lucee-server/scope.html), [Ortis Books](https://modern-cfml.ortusbooks.com/cfml-language/variable-scopes), [Adobe About Scope](https://helpx.adobe.com/coldfusion/developing-applications/the-cfml-programming-language/using-coldfusion-variables/about-scopes.html)


---

## Arrays

```js
component {
    tools = ["hammer", "screwdriver", "drill", "ruler"]

    tools.sort("textnocase")

    tools = [] // clear or init empty

    tools.delete("hammer")
    tools.deleteAt(1) // deletes hammer

    // iterate
    tools.each(function(tool, index) {
        echo("#index#. #tool#")
    })

    // filter
    // returns any tools containing the string "screw"
    tools.filter(function(tool) {
        return tool.containsNocase("screw") ? true : false;
    })

    // loop
    for(var tool in tools) {
        echo("I have a #tool#")
    }

    // multi-thread loop processing
    // each( collection, callback, parallel:boolean, maxThreads:numeric );
    toolCount = len(tools)
    tools.each(function(tool){
        handle(tool); // some outside or global function
    }, true, toolCount)
}
```

### [Ortis Books](https://modern-cfml.ortusbooks.com/cfml-language/arrays)

---

## Structures

```js
component {

    tools = {
        "hammers" = 3
        "screwdrivers" = 1
        "drills" = 1
        "rulers" = 2
    }

    // update values
    tools.hammers = 2
    tools["hammers"] = 2

    // empty or init
    tools = {}

    tools.count() // 4
    tools.isEmpty() // false
    tools.keyExists("hammers") // true

    for(var tool in tools) {
        echo("I have #tools[tool]# #tool#s.")
    }

    tools.each(function(key,value) {
        echo("I have #value# #key#s.")
    });
}
```

---

## Database query results

```html

<cfoutput query="items">
    There are #item.count# in #item.name#<br>
</cfoutput>

```

```js

for(var row in items) {
    echo("There are #item.count# in #item.name#")
}

items.each(function(item,index){
    echo("#index#. There are #item.count# in #item.name#")
});

for(var i = 1; i lte items.recordCount; i++){
    echo("#i#. There are #item.count[i]# in #item.name[i]#")
}
```

---

## Conditionals

### Operators

```js
a = 1; // set
if( a == 1 ) // equal
if( a > 2 ) // gt
if( a < 2 ) // lt
if( a != 2 ) // not equal
if( a >= 1 ) // gte
if( a <= 1 ) // lte
```

### Ternary operator

```js
// ( condition ) ? trueStatement : falseStatement

x = "apple"
y = "orange"

(x == y) ? echo("true") : echo("false"); // false

```

### Elvis operator

```js
// replacement for if isDefined(), if structKeyExists()

myName = userName ?: "anonymous"; // set myName to userName, unless undefined or null, then set it to "anonymous"
```

### Safe navigation operator

```js
// legacy method
result = ""
if (structKeyExists(var, "key")) {
    if(structKeyExists(var.key, "anotherKey")) {
        result = var.key.anotherKey
    }
}

// safe navigation method with elvis operator
result = var?.key?.anotherKey ?: "";
```

### Mathematical operators

```js
1+1 // 2, add
1-1 // 0, subtract
2*2 // 4, multiply
10/5 // 2, divide

2^2 // 4, exponentiate
5%2 // 1, modulus (remainer)
5 MOD 2 // 1, modulus
7\2 // 3, integer divide (no remainder)
1++ // 2, increment (not thread safe)
1-- // 0, decrement (not thread safe)
x = 5
x+=1 // 6, compound add
x = 5
x-=1 // 4, compound subtract
x = 5
x*=2 // 10, compound multiply
x = 6
x/=2 // 3, compund divide
```

### Logical operators

```js
! // logical inversion
NOT // logical inversion
AND // logical and
&& // logical and
OR // logical or
|| // logical or
XOR // logical exclusive or
```

### Comparison operators

```js
EQ // equals
== // equals
=== // identical (same object in memory)
NEQ // <> does not equal
!= // does not equal
!== // is not idential (same object in memory)
GT // greater than
> // "
LT // less than
< // "
GTE // greater than or equal
>= // "
LTE // less than or equal
<= // "

CONTAINS // contains
CT // "
DOES NOT CONTAIN // does not contain
NCT // "
```

### String operator

```js
& // concatenation
&= // compound concatenation

"Hello" & "world" // Helloworld

h = "Hello"
h &= "world"
echo(h) // Helloworld
```

### While loops

```js
state = true
count = 0
while(state) {
    count++
    if (count == 10) {
        state = false
    }
}
echo(count) // 10


loop times="10" {
    echo("Hi!") // print 10 times
}

```

### [Ortis Books](https://modern-cfml.ortusbooks.com/cfml-language/conditionals)

---

## Components

### Construct

```js
// User.cfc
component {
    property name="name"
    property name="age" type="numeric"

    function init(required name) {
        variables.name = arguments.name
        return this
    }

    function run(){
        echo("Hello, my name is #name#.")
    }
}

// elsewhere
user = new User(name="Ben") // init by providing the required name
user.run() // Hello, my name is Ben.
```

### Attributes

* accessors - Enables automatic getters/setters for properties
* extends - Provides inheritance via the path of the Component (CFC)
* implements - Names of the interfaces it implements
* persistent - Makes the object a Hibernate Entity which can be fine tuned through a slew of other attributes.
* serializable - Whether the component can be serialized into a string/binary format or not. Default is true.

```js
component accessors="true" serializable="false" extends="BaseUser"{}
```

### Properties

* type - A valid CFML type
* default - Default value when the object is created, else defaults to null.

```js
property name="firstName" default="";
property name="lastName" default="";
property name="age" type="numeric" default="0";
property name="address" type="array";
```

### Functions

#### Visibility context

* public - Available to the component and externally
* private - Available only to the component that declares the method and any components that extend the component in which it is defined.
* package - Available only to the component that declares the method, components that extend the component, or any other components in the package.
* remote - Available to a locally or remotely executing page or component method, or a remote client through a URL,
Flash, or a web service. To publish the function as a web service, this option is required.

### Static constructors

The static constructor is execute once before the component is loaded for the first time, so every component of the same type will share the same static scope.

```js

component NewLines {
    static {
        lf: 10,
        cr: 13
    }

    public static function linefeed(){
        return chr(lf)
    }
    public static function carriageReturn(){
        return chr(cr)
    }
}

// to access outside of the commonent
NewLines::lf;
NewLines::linefeed();
```

---

## Life-Cycle Events

* **onApplicationStart**: Defacto2 application starts. It happens once only, is resets when either the application timesout or Lucee is restarted.
* **onSessionStart**: A new user requests any resource hosted by Lucee.
* **onRequestStart**: A request for any resource hosted by Lucee.

+ **onRequestEnd**: RequestStart is complete and `targetPage` is now known.
+ **onSessionEnd**: Existing user session timesout or ends.
+ **onApplicationEnd**: Application has timed out.

* **onError**: A global exception catcher that covers the whole application.
* **onAbort**: Triggered whenever a `<cfabort>` or `abort` are used so you can `dump(targetPage)`.
* **onMissingTemplate**: A global catch for templates that are requested by don't exist on the server.

---

## Asynchronous programming

```js

hi = runAsync(function(){
    return "Hello world!"
});
echo(hi.get()) // run in background, no timeout
result = hi.get(3) // 3 ms timeout
echo(result) // run in background

age = runAsync(function(){
    return 1990
}).then(function(input){
    return now().year() - input
})
result = age.get(1) // 1 ms timeout
echo(result) // run in background

```

### [ortusbooks](https://modern-cfml.ortusbooks.com/beyond-the-100/asynchronous-programming)

---

## Placeholders

### Directories

+ `{lucee-web}` path to the Lucee web directory, usually `{web-root}/WEB-INF/lucee`
+ `{lucee-server}` path to the Lucee server directory, usually where `lucee.jar` is located.
+ `{lucee-config}` either the above to depending on context.
+ `{temp-directory}` path to the temporary directory.
+ `{home-directory}` path to the home directory of the Lucee user.
+ `{web-root-directory}` path to the web root.
+ `{system-directory}` path to the system directory.
+ `{web-context-hash}` hash of the web context
+ `{web-context-label}` label of the web context