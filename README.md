DTBookMenuController
==========================
![Demo](https://raw.github.com/Darktt/DTBookMenuController/master/Raw/Image/Perview.png)

##Installation##
Drag the <code>DTBookMenuController</code> folder into your project.

##Usage##
Import the header file and declare in your appDelegate.

	#import "DTBookMenuController"

Initializing DTBookMenuController in appDelegate:
``` objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
~
~
DTFirstViewController *first = [DTFirstViewController new];
DTSecoundViewController *secound = [DTSecoundViewController new];
    
DTBookMenuController *menuView = [DTBookMenuController menuViewWithViewControllers:@[first, secound]];
[first release];
[secound release];

[self.window setRootViewController:menuView];
~
~
}
```

Set menu title at each viewController:
``` objective-c
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	[self setTitle:@"Menu Title"];
}
```

##License##
Licensed under the Apache License, Version 2.0 (the "License");  
you may not use this file except in compliance with the License.  
You may obtain a copy of the License at

>[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)
 
Unless required by applicable law or agreed to in writing,  
software distributed under the License is distributed on an  
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,  
either express or implied.   
See the License for the specific language governing permissions  
and limitations under the License.