# MINT dataset analyzer #



The work was done under supervision of Prof. Kristiina Jokinen under the auspices of the Estonian Science Foundation Project ETF8958, Multimodal Interaction (MINT), and the project IUT-20-56, Computational Models for Estonian.

## The work is reported in: ##

* Vels, M. and Jokinen, K. (2014). Recognition of Human Body Movements for Studying Engagement in Conversational Video Files. Proceedings of the 2nd European and the 5th Nordic Symposium on Multimodal Communication, August 6-8, 2014, Tartu, Estonia [http://www.ep.liu.se/ecp_article/index.en.aspx?issue=110;article=013](http://www.ep.liu.se/ecp_article/index.en.aspx?issue=110;article=013)

* Vels, M. and Jokinen, K. (2015). Detecting Body, Head, and Speech Signals for Conversational Engagement. In proceedings of the IVA Workshop "Engagement in Social Intelligent Virtual Agents" (ESIVA-2015), August 25, 2015, Delft, The Netherlands.

* Jokinen, K. (2015). Detection of Communicative Co-speech Gesturing in Conversations. Presentation at the 3rd European Symposium on Multimodal Communication (MM-SYM) September 18, 2015, Dublin, Ireland. 


## Usage ##
* Speech parser: parses ANVIL annotation files and extracts speech data into CSV-files. 

    To run: <code>python speech_parser.py</code>
    
* Frame extractor: detect human head, body and legs in video frames and saves surrounding box coordinates of the objects into CSV-files.

    To run: <code>python frame_extractor.py</code>
    
* Head, body, speech and hand movement diagram generation is done with Matlab using code in analyzer folder. Code that generates the diagram is in <code>generate_diagram.m</code>. This code uses several other matlab functions in analyzer folder. 
    
