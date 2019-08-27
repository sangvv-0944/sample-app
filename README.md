# Ruby on Rails sample application

## License

All source code in the [Ruby on Rails Tutorial](https://www.railstutorial.org/)
is available jointly under the MIT License and the Beerware License. See
[LICENSE.md](LICENSE.md) for details.

---
Clone the repo and install the needed gems:
```sh
$ bundle install --without production
```
Migrate database
```sh
$ rails db:migrate
```
Run check code convention
```sh
$ bundle excec ruboco
```
Finally, run the test suite to verify that everything is working correctly:
```sh
$ rails test
```
If the test suite passes, you'll be ready to run the app in a local server:
```sh
$ rails server
```
