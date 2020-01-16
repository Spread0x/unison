
Things we want to test:

* Diffing identical namespaces
* Adds, removes, updates (with and without metadata updates)
  * Adds with multiple names
  * Adds with multiple names and different metadata on each
* Moved and copied definitions
  * Moves that have more that 1 initial or final name
* ... terms and types
* New patches, modified patches, deleted patches, moved patches
* With and without propagated updates

```unison
fromJust = 1
b = 2
bdependent = b
c = 3
helloWorld = '(printLine "Hello, world!")

type A a = A Nat
ability X a1 a2 where x : Nat
```

```ucm
  ☝️  The namespace .ns1 is empty.

.ns1> add

  ⍟ I've added these definitions:
  
    type A a
    ability X a1 a2
    b          : Nat
    bdependent : Nat
    c          : Nat
    fromJust   : Nat
    helloWorld : ∀ (). () ->{IO} ()

.ns1> alias.term fromJust fromJust'

  Done.

.ns1> alias.term helloWorld helloWorld2

  Done.

.ns1> link fromJust b

  Done.

.ns1> fork .ns1 .ns2

  Done.

.ns1> cd .

```
Here's what we've done so far:
```ucm
.> diff.namespace nothing ns1

  Added definitions:
  
    1.  ability X a1 a2
    2.  type A a
    3.  X.x           : {X a1 a2} Nat
    4.  A.A           : Nat -> A a
    5.  b             : Nat
    6.  bdependent    : Nat
    7.  ┌ fromJust    : Nat (+1 metadata)
    8.  └ fromJust'   : Nat (+1 metadata)
    9.  ┌ helloWorld  : ∀ (). () ->{IO} ()
    10. └ helloWorld2 : ∀ (). () ->{IO} ()
    11. c             : Nat

.> diff.namespace ns1 ns2

  The namespaces are identical.

```
```unison
fromJust = "asldkfjasldkfj"
```

```ucm
  ☝️  The namespace .ns1b is empty.

.ns1b> add

  ⍟ I've added these definitions:
  
    fromJust : Text

.> merge ns1b ns1

  Here's what's changed in ns1 after the merge:
  
  The namespaces are identical.
  
  Tip: You can use `todo` to see if this generated any work to
       do in this namespace and `test` to run the tests. Or you
       can use `undo` or `reflog` to undo the results of this
       merge.

```
```unison
fromJust = 99
b = "oog"
d = 4
e = 5
f = 6
unique type Y a b = Y a b
```

```ucm
.ns2> update

  ⍟ I've added these definitions:
  
    unique type Y a b
    d : .builtin.Nat
    e : .builtin.Nat
    f : .builtin.Nat
  
  ⍟ I've updated to these definitions:
  
    b        : .builtin.Text
    fromJust : .builtin.Nat

  ✅
  
  No conflicts or edits in progress.

.ns2> links fromJust

  1. .ns1.b : Nat
  
  Tip: Try using `display 1` to display the first result or
       `view 1` to view its source.

.> diff.namespace ns1 ns2

  Resolved name conflicts:
  
    1.  ┌ fromJust#hs2i9lcgkd : Text
    2.  └ fromJust#jk19sm5bf8 : Nat
        ↓
    3.  fromJust#1o1iq26cq7 : Nat
        + 4.  ns1.b : Nat
  
  Updates:
  
    5.  b#0ja1qfpej6 : Nat
        ↓
    6.  b#ao6k44sjr0 : Text
    
    7.  fromJust'#jk19sm5bf8 : Nat
        ↓
    8.  fromJust'#1o1iq26cq7 : Nat
        + 9.  ns1.b : Nat
  
    & 1 auto-propagated updates
  
  Added definitions:
  
    10. unique type Y a b
    11. Y.Y : a -> b -> Y a b
    12. d   : Nat
    13. e   : Nat
    14. f   : Nat
  
    15. patch patch (added 2 updates)

.> alias.term ns2.d ns2.d'

  Done.

.> alias.type ns2.A ns2.A'

  Done.

.> alias.type ns2.X ns2.X'

  Done.

.> diff.namespace ns1 ns2

  Resolved name conflicts:
  
    1.  ┌ fromJust#hs2i9lcgkd : Text
    2.  └ fromJust#jk19sm5bf8 : Nat
        ↓
    3.  fromJust#1o1iq26cq7 : Nat
        + 4.  ns1.b : Nat
  
  Updates:
  
    5.  b#0ja1qfpej6 : Nat
        ↓
    6.  b#ao6k44sjr0 : Text
    
    7.  fromJust'#jk19sm5bf8 : Nat
        ↓
    8.  fromJust'#1o1iq26cq7 : Nat
        + 9.  ns1.b : Nat
  
    & 1 auto-propagated updates
  
  Added definitions:
  
    10. unique type Y a b
    11. Y.Y  : a -> b -> Y a b
    12. ┌ d  : Nat
    13. └ d' : Nat
    14. e    : Nat
    15. f    : Nat
  
    16. patch patch (added 2 updates)
  
  Name changes:
  
    Original  Changes
    17. X     18. X' (added)
    
    19. A    20. A' (added)

.> link ns2.f ns1.c

  Done.

.> link ns2.c ns2.c

  Done.

.> diff.namespace ns1 ns2

  Resolved name conflicts:
  
    1.  ┌ fromJust#hs2i9lcgkd : Text
    2.  └ fromJust#jk19sm5bf8 : Nat
        ↓
    3.  fromJust#1o1iq26cq7 : Nat
        + 4.  ns1.b : Nat
  
  Updates:
  
    5.  b#0ja1qfpej6 : Nat
        ↓
    6.  b#ao6k44sjr0 : Text
    
    7.  c#msp7bv40rv : Nat
        + 8.  c : Nat
    
    9.  fromJust'#jk19sm5bf8 : Nat
        ↓
    10. fromJust'#1o1iq26cq7 : Nat
        + 11. ns1.b : Nat
  
    & 1 auto-propagated updates
  
  Added definitions:
  
    12. unique type Y a b
    13. Y.Y  : a -> b -> Y a b
    14. ┌ d  : Nat
    15. └ d' : Nat
    16. e    : Nat
    17. f    : Nat (+1 metadata)
  
    18. patch patch (added 2 updates)
  
  Name changes:
  
    Original  Changes
    19. X     20. X' (added)
    
    21. A    22. A' (added)

.> unlink ns2.fromJust ns2.b

  Done.

.> diff.namespace ns1 ns2

  Resolved name conflicts:
  
    1.  ┌ fromJust#hs2i9lcgkd : Text
    2.  └ fromJust#jk19sm5bf8 : Nat
        ↓
    3.  fromJust#1o1iq26cq7 : Nat
        + 4.  ns1.b : Nat
  
  Updates:
  
    5.  b#0ja1qfpej6 : Nat
        ↓
    6.  b#ao6k44sjr0 : Text
    
    7.  c#msp7bv40rv : Nat
        + 8.  c : Nat
    
    9.  fromJust'#jk19sm5bf8 : Nat
        ↓
    10. fromJust'#1o1iq26cq7 : Nat
        + 11. ns1.b : Nat
  
    & 1 auto-propagated updates
  
  Added definitions:
  
    12. unique type Y a b
    13. Y.Y  : a -> b -> Y a b
    14. ┌ d  : Nat
    15. └ d' : Nat
    16. e    : Nat
    17. f    : Nat (+1 metadata)
  
    18. patch patch (added 2 updates)
  
  Name changes:
  
    Original  Changes
    19. X     20. X' (added)
    
    21. A    22. A' (added)

.> alias.type ns1.X ns1.X2

  Done.

.> alias.type ns2.A' ns2.A''

  Done.

.> view.patch ns2.patch

  Edited Terms:
    ns1.b         -> ns2.b
    ns1.fromJust' -> ns2.fromJust

.> fork ns2 ns3

  Done.

.> alias.term ns2.fromJust' ns2.yoohoo

  Done.

.> delete.term ns2.fromJust'

  Name changes:
  
    Original            Changes
    1. ns2.fromJust  ┐  2. ns2.fromJust' (removed)
    3. ns2.fromJust' │  
    4. ns2.yoohoo    │  
    5. ns3.fromJust  │  
    6. ns3.fromJust' ┘  
  
  Tip: You can use `undo` or `reflog` to undo this change.

.> diff.namespace ns3 ns2

  Name changes:
  
    Original        Changes
    1. fromJust  ┐  2. yoohoo (added)
    3. fromJust' ┘  4. fromJust' (removed)

```
##

Updates:  -- 1 to 1

New name conflicts: -- updates where RHS has multiple hashes (excluding when RHS=LHS)

  1. foo#jk19sm5bf8 : Nat - do we want to force a hashqualified? Arya thinks so
     ↓
  2. ┌ foo#0ja1qfpej6 : Nat
  3. └ foo#jk19sm5bf8 : Nat  

Resolved name conflicts: -- updates where LHS had multiple hashes and RHS has one

  4. ┌ bar#0ja1qfpej6 : Nat
  5. └ bar#jk19sm5bf8 : Nat  
     ↓
  6. bar#jk19sm5bf8 : Nat  

## Display issues to fixup

- [ ] check whether creating a name conflict + adding metadata puts the update
      in both categories; if it does, then filter out metadataUpdates from the
      other categories
- [ ] just handle deletion of isPropagated in propagate function, leave HandleInput alone (assuming this does the trick)
- [ ] if a name is updated to a not-yet-named reference, it's shown as both an update and an add
- [ ] similarly, if a conflicted name is resolved by deleting the last name to
      a reference, I (arya) suspect it will show up as a Remove
- [ ] might want unqualified names to be qualified sometimes:

    .a> merge .b

      Updates:

        1. foo : Nat  - here?
           ↓
        2. ┌ foo#0ja1qfpej6 : Nat
        3. └ foo#jk19sm5bf8 : Nat

      Adds:

        4. foo#0ja1qfpej6 : Nat

    maybe if all of the old (n,r) are still present, but some new (n,r') has
    been added, just show it under adds:

      Adds:

        1. foo#0ja1qfpej6 : Nat  -- and the hash indicates that it has become conflicted?

- [ ] Do we want to surface new edit conflicts in patches?
- [ ] incorrectly calculated bracket alignment on hashqualified "Name changes"  (delete.output.md)

    Original                               Changes
    4. example.resolve.a.foo ┐             5. example.resolve.c.foo#jdqoenu794 (removed)
    6. example.resolve.c.foo#jdqoenu794 ┘  

- [ ] two different auto-propagated changes creating a name conflict should show
      up somewhere besides the auto-propagate count
- [ ] Things look screwy when the type signature doesn't fit and has to get broken
      up into multiple lines. Maybe just disallow that?
- [ ] Delete blank line in between copies / renames entries if all entries are 1 to 1
      see todo in the code
- [ ] ~~Maybe group and/or add headings to the types, constructors, terms~~
- [x] add tagging of propagated updates to test propagated updates output
- [x] missing old names in deletion ppe (delete.output.md)  (superseded by \#1143)
- [x] delete.term has some bonkers output
- [x] Make a decision about how we want to show constructors in the diff
- [x] When you delete a name with metadata, it also shows up in updates section
      with the deleted metadata.
- [x] An add with new metadata is getting characterized as an update
- [x] can there be a metadata-only update where it's not a singleton old and new reference
- [x] 12.patch patch needs a space
- [x] This looks like garbage
- [x] Extra 2 blank lines at the end of the add section
- [x] Fix alignment issues with buildTable, convert to column3M (to be written)
- [x] adding an alias is showing up as an Add and a Copy; should just show as Copy
- [x] removing one of multiple aliases appears in removes + moves + copies section
- [x] some overlapping cases between Moves and Copies^
- [x] Maybe don't list the type signature twice for aliases?