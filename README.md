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
![image]()
----------------
![image](https://cloud.githubusercontent.com/assets/5080310/13752458/c6f669b4-ea34-11e5-85f3-f6c7867790fd.png)
----------------
![image](https://cloud.githubusercontent.com/assets/5080310/13752460/c7393eba-ea34-11e5-8c72-8d5cad37a610.png)
----------------
![image](https://cloud.githubusercontent.com/assets/5080310/13752462/c760e6ea-ea34-11e5-8281-7ace1c64315c.png)
----------------
![image](https://cloud.githubusercontent.com/assets/5080310/13752459/c736ccca-ea34-11e5-8895-6ffad330bbf4.png)
----------------
![image](https://cloud.githubusercontent.com/assets/5080310/13752461/c75bab8a-ea34-11e5-884b-1b377ec384be.png)
----------------




## Possible improvements

- Use capitalization data - right now we are using lowercased data. But anecdotally it seems like spams have a higher chance of being in all caps [ __shouting__ , __Supurios offers__, etc ].

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