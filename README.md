# Ruby Red Black Tree

This is a simple red-black tree implementation I did for practice. If you got here, then hopefully this code can help you out. Use it however you like, as I've not included a license.

## Example use

```
$ script/console
/Users/dave/code/red-black-tree/script
irb(main):001:0> tree = RedBlackTree::Builder.random_tree(10)
=> #<RedBlackTree:0x007f9c90ba5e58 @root=<RedBlackTree::Node key=6375 parent=nil left_child=3856 right_child=7321 />>
irb(main):002:0> pdf_path = RedBlackTree::Visualizer.draw(tree, "test.pdf")
=> "test.pdf"
irb(main):003:0> `open #{pdf_path}`
=> ""
irb(main):004:0>
```

## Ruby Version

I built this with [MRI 2.1.2](https://www.ruby-lang.org/en/news/2014/05/09/ruby-2-1-2-is-released/), but it also runs with 1.9.3. I have some 1.9 style hash syntax in there, so 1.8 won't work without some tweaking.

## Visualizing Trees

You need to `brew install graphviz` or install [Graphviz](http://www.graphviz.org) by hand. This will allow you to output trees as images. The graphviz gem outputs whatever file type you give it, based on the desired output filename. I use PDFs as I find them easier to view on my system, but most anything seems to work. If you install by hand then you might have to install other dependencies to get the filetypes you want.
