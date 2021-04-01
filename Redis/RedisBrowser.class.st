Class {
	#name : #RedisBrowser,
	#superclass : #RedisPresenter,
	#instVars : [
		'connectionList'
	],
	#category : #'Redis-GUI'
}

{ #category : #specs }
RedisBrowser class >> defaultLayout [
	^ SpBoxLayout newVertical
		add: #filmList;
		yourself
]

{ #category : #initialization }
RedisBrowser >> initializePresenters [ 
	connectionList := self newTreeTable 
		addColumn: (SpCompositeTableColumn new 
			addColumn: (SpImageTableColumn new
				width: 20;
				evaluated: [:server | server image];
				yourself);
			addColumn: (SpStringTableColumn new
				evaluated: [:node | node name];
				yourself)
			yourself);
		addColumn: (SpCompositeTableColumn new 
			addColumn: (SpImageTableColumn new
				width: 20;
				evaluated: [:server | server image];
				yourself);
			addColumn: (SpStringTableColumn new
				evaluated: [:node | node name];
				yourself)
			yourself);
		addColumn: (SpCompositeTableColumn new 
			addColumn: (SpImageTableColumn new
				width: 20;
				evaluated: [:server | server image];
				yourself);
			addColumn: (SpStringTableColumn new
				evaluated: [:node | node name];
				yourself)
			yourself);
		yourself	
				 
]

{ #category : #initialization }
RedisBrowser >> initializeWindow: aWindowPresenter [
	aWindowPresenter 
		title: 'Redis';
		initialExtent: 600@400;
      toolBar: (self newToolBar
    		addItem: (self newToolBarButton
				label: 'Add film' ;
				icon: (self application iconNamed: #smallAdd);
				action: [ self addServer ];
          	yourself);
	yourself)
]
