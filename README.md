# Grocery List-iOS
Keep track of your grocery list while meal planning. Store your recipe ingredient requirements within the app. Add all the ingredients for a recipe to your grocery list at the tap of a button.

# Technologies
This app uses a MVVM architecture with [ReactiveKit](https://github.com/DeclarativeHub/ReactiveKit) and [Bond](https://github.com/DeclarativeHub/Bond). Data persistence is handled by [Realm](https://realm.io/docs/swift/latest/). [Alamofire](https://github.com/Alamofire/Alamofire) will be used for API requests (when implemented) and [Gloss](https://github.com/hkellaway/Gloss) is used for JSON decoding. [R.swift](https://github.com/mac-cain13/R.swift) is used for strongly typed resource access.

# Getting Started
Clone the repository. From the terminal, run `pod install` to download the required pods.
Build the project to generate the required R.swift file. 

If there is any issue, see the R.swift documentation [here](https://github.com/mac-cain13/R.swift/blob/master/README.md) (under CocoaPods installation).

# TODO
- [ ] Delete confirmation when deleting recipes
- [ ] Look into handling pluralizations of items
- [ ] Redesign UI to be prettier
- [ ] Ensure keyboard never obscures text fields
- [ ] Sort recipes alphabetically
- [ ] Setup Alamofire routers

# Screenshots
Grocery List                          |  Recipes List                         | Recipe Ingredient List
:------------------------------------:|:-------------------------------------:|:------------------:
![](https://i.imgur.com/n2Sg3Cp.png)  |  ![](https://i.imgur.com/aJkPW6p.png) | ![](https://i.imgur.com/ZPYxe7i.png)

# License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
