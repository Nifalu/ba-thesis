#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, algorithm

== Usage
The tool was developed to minimise human input and reduce the likelihood of misleading outputs caused by user errors. Consequently, the tool is simple to use:

*Note:* This is a simple demonstration of the tool. If you plan to use it with your own components, please read the `README` on the GitHub repository for more details.

*Prerequisites:* Clone the repository and install. Make sure you have a working Python environment with the packages listed in `requirements.txt` installed. The tool was developed and tested with Python 3.13.

*Steps to run the MCS Analyser:*

1. Run the *MCS Analyser* with the following command:
```bash
python main.py --config <config.json>
```

2. View the resulting graph on #link("http://localhost:8080")[`http://localhost:8080`]
