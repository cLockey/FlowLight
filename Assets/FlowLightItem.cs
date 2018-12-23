using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FlowLightItem : MonoBehaviour {

    public RawImage mainImage;
    public Texture2D lightTex;
    [Range(0, 5)]
    public float lightPower = 1;
    public Material Material;

    public float defaultOffset = -0.3f;
    public float duration = 2f;
    public float interval = 2f;

    private Material mDynaMaterial;
    // Use this for initialization
    void Start () {
		if(mainImage == null)
        {
            mainImage = GetComponent<RawImage>();
        }

        if (mDynaMaterial == null)
        {
            mDynaMaterial = new Material(Material);
            mDynaMaterial.name = mDynaMaterial.name + "(Copy)";
            mDynaMaterial.hideFlags = HideFlags.DontSave | HideFlags.NotEditable;
            mDynaMaterial.mainTexture = mainImage.mainTexture;
            mainImage.material = mDynaMaterial;
        }

        mainImage.material.SetTexture("_MainTex", mainImage.texture);
        mainImage.material.SetTexture("_LightTex", lightTex);
        mainImage.material.SetFloat("_LightPower", lightPower);
        
    }

    public void Init(float startTimeOffset)
    {
        _startTime = Time.realtimeSinceStartup;
        _startTimeOffset = startTimeOffset;
    }

    private float _startTime;
    private float _startTimeOffset;

    void Update ()
    {
        float passedTime = (Time.realtimeSinceStartup - _startTime) - _startTimeOffset;
        if(passedTime > 0 && passedTime % (duration + interval) < duration)
        {
            mainImage.material.SetInt("_Enabled", 1);
            mainImage.material.SetFloat("_TimeOffset", passedTime / duration + defaultOffset);
        }
        else
        {
            mainImage.material.SetInt("_Enabled", 0);
        }
	}
}
