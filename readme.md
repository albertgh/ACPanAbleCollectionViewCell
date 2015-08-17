## ACPanAbleCollectionViewCell

A panable UICollectionViewCell subclass with customizable actionView.


<img src="https://github.com/albertgh/ACPanAbleCollectionViewCell/raw/master/screenshot.gif"/>


## Installing

Drag `ACPanAbleCollectionViewCell` folder into your project. 

inherit `ACPanAbleCollectionViewCell`
    
    
## Usage

- Initialize actionView in your subclass of `ACPanAbleCollectionViewCell`.
- Creat `ACPACVCActionItem` with your own action.
- Pass the array with actionItems into your `ACPACVCActionView` member variable.
- Add it on cell.

```objc
NSMutableArray *actionItemsMArray = [[NSMutableArray alloc] init];

ACPACVCActionItem *deleteActionItem =
[[ACPACVCActionItem alloc] initWithFrame:CGRectZero];
deleteActionItem.backgroundColor = [UIColor redColor];
deleteActionItem.itemWidth = 60.0;
[deleteActionItem configItemWithActionBlock:^{
    // your action here
    // don't forget to avoid retain cycle
} textString:@"delete"];
[actionItemsMArray addObject:deleteActionItem];

self.actionView =
[[ACPACVCActionView alloc] initWithActionItemsArray:actionItemsMArray];
    
[self pac_addRightActionView:self.actionView];
```

See the details in example project.


## TODO

- If actionView is opened, allows only actions on actionView or close actionView
- Add bounces effect for panGesture 


#### Requirements

* iOS 7+


#### License

* MIT 


