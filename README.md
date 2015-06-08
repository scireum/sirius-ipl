# sirius-ipl

This "Initial Program Load" contains a single Java main class which can be started from the IDE or via the supplied service
scipts **sirius.sh** for Linux and **Apache prunsrv** for Windows.

The **sirius-app-parent** pom automatically includes this and builds a release zip containing all required resources.

This is a module of the Sirius OpenSource project by scireum GmbH. For further information visit the project website: [sirius-lib.net](http://sirius-lib.net)

If you have questions or are just curious, please feel welcome to join the chat room:
[![Join the chat at https://gitter.im/scireum/OpenSource](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/scireum/OpenSource?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Usage

The **sirius-app-plugin** (see https://github.com/scireum/sirius-build) uses the maven-assembly-plugin to attache the resources contained in this atrifact to the release zip. Nearly all Sirius applications also use the **IPL** class in the
IDE to start a debugger.

Consult the [README](src/main/resources/README) which is also being shipped in the root directory of the resulting zip
on how to start / stop / install a Sirius application.

## License

SIRIUS is licensed under the MIT License:

> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.

