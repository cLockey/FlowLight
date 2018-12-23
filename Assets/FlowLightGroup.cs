using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FlowLightGroup : MonoBehaviour {

    public RectTransform groupRect;
    public FlowLightItem[] items;
    public float duration = 7;

    private float width, height;
	// Use this for initialization
	void Start () {
        width = groupRect.sizeDelta.x;
        height = groupRect.sizeDelta.y;
        _startTime = Time.realtimeSinceStartup;
        InitItems();
    }

    void InitItems()
    {
        for(int i=0; i<items.Length; i++)
        {
            items[i].Init(CalcTimeOffset(items[i].GetComponent<RectTransform>()));
        }
    }
	
    float CalcTimeOffset(RectTransform trans)
    {
        float width = groupRect.sizeDelta.x;
        return (trans.localPosition.x + width / 2 - trans.sizeDelta.x/2) / width * duration;
    }

    float _startTime;
    private void Update()
    {
        float passedTime = Time.realtimeSinceStartup - _startTime;
        if(passedTime > duration)
        {
            _startTime = Time.realtimeSinceStartup;
            InitItems();
        }
    }
}
