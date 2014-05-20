import sys
from lxml import etree

dict = {}
with open('/home/andrej/Documents/dev/mesh/mesh_uid2name.txt') as myfile:
  for line in myfile:
    mesh_descriptor_uid, name = line.split('|')
    name = name.rstrip('\n')
    dict[name] = mesh_descriptor_uid

file_name = sys.argv[1]
tree = etree.parse(file_name)
element = tree.getroot()

for sub_element in element:
  try:
    pmid = sub_element.xpath('PMID')
    bla = sub_element.xpath('MeshHeadingList/MeshHeading')
    #print len(bla)
    for desc in bla:
      major_topic = desc[0].attrib['MajorTopicYN']
      print(pmid[0].text + '|' + dict[desc[0].text] + '|' + major_topic)
      #print pmid[0].text + '|' + desc[0].text
  except:
    pass


