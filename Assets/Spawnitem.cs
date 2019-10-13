using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spawnitem : MonoBehaviour
{
    public GameObject [] spawnee;
    public bool stopSpawning = false;
    public float spawnTime;
    public float spawnDelay;

    // Use this for initialization
    void Start()
    {
        InvokeRepeating("SpawnObject", spawnTime, spawnDelay);
    }
    int GetRandom(int count)
    {
        return Random.Range(0, count);
    }
    public void SpawnObject()
    {
        int randomitem = GetRandom(spawnee.Length);
        Instantiate(spawnee[randomitem], transform.position, transform.rotation);
        if (stopSpawning)
        {
            CancelInvoke("SpawnObject");
        }
    }
}



