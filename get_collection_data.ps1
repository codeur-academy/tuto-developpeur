
# fihcier google sheet publier =  https://docs.google.com/spreadsheets/d/e/2PACX-1vSOU2favoVi2dojkph7iMx-YBVbbtpwUWf6nnw-dxYdhKWcEZjxa5ZZH-ARKChhbejooKZ2wGWdbDE3/pub?output=xlsx

Invoke-WebRequest -Uri https://docs.google.com/spreadsheets/d/e/2PACX-1vSOU2favoVi2dojkph7iMx-YBVbbtpwUWf6nnw-dxYdhKWcEZjxa5ZZH-ARKChhbejooKZ2wGWdbDE3/pub?output=xlsx -OutFile _data/collections.xlsx
