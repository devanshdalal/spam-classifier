# spam-classifier
Spam classifier using Support Vector Machines 

<!-- SVMs are really accurate if used properly. but resource used are a tradeoff. -->

## The training data 

The training data is present in file _train_ and _train-small_ while unlabled data is present in file _test_

## Usage

Implementation is done using CVX package for convex-optimization which was later compared with classification done using LibSVM for matlab.<br>

Each matlab script properly documented and it explains what it is doing.

## Theory & Performance

----------------
![image](https://cloud.githubusercontent.com/assets/5080310/13757405/45092b56-ea4a-11e5-8926-d0dc9681d2f3.jpg)
----------------
![image](https://cloud.githubusercontent.com/assets/5080310/13757406/45123480-ea4a-11e5-8893-98c6c6df4591.jpg)
----------------
![image](https://cloud.githubusercontent.com/assets/5080310/13757407/451574a6-ea4a-11e5-8088-954b90ff1dd0.jpg)

## Possible improvements

- Use capitalization data - right now we are using lowercased data. But anecdotally it seems like spams have a higher chance of being in all caps [ _shouting_ , _Supurios offers_, etc ].

- Use punctuation - the classifier doesn't really use punctuation, this is most likely a mistake because spams seem to have a lot of weird punctuation and ascii art.

- Search for keywords - just tokenizing the comment isn't the best because a lot of spam comments look like "pleasecheckoutmyfacebookpageatwwwfacebookcom/blah"

- Most of the feature which are used in twitter-sentiment-analyis can be used. 


## Contributing

1. Fork it!
2. Create your branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -m 'Added Some featues'``
4. Push to the branch: 	`git push origin my-new-feature`
5. Submit a pull request :)

## Credits

- Devansh Dalal ([@devanshdalal](https://github.com/devanshdalal)) <br>